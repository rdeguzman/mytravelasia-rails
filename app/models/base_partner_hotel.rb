#Do not use this class directly
class BasePartnerHotel < ActiveRecord::Base
  attr_accessor :page
  attr_accessor :error_code
  attr_accessor :weight

  enum_attr :status,  %w(seed new not_found inactive valid valid_unique valid_matched valid_manual valid_for_check duplicate)
  #valid_matched is matched to a poi table

  validates :hotel_name, :presence => true
  validates :address, :presence => true

  scope :no_location, :conditions => 'longitude is null AND latitude is null'
  scope :recently_added, :conditions => 'current_status = "new"'
  scope :currently_valid, :conditions => 'current_status = "valid" OR current_status = "valid_unique" OR current_status = "valid_matched"'
  scope :valid_only, :conditions => 'current_status = "valid"'
  scope :not_poi_matched, :conditions => 'poi_id is null OR poi_id = 0'

  def page_exists?(path)
    begin
      @agent = Mechanize.new
      @page = @agent.get(path)

    rescue Net::HTTP::Persistent::Error => e

      @error_code = "connection_refused"
      return false

    rescue Mechanize::ResponseCodeError => e

      @error_code = "not_found"
      return false

    rescue Exception => e

      @error_code = "unknown"
      return false

    end

    return true
  end

  def has_location?
    return !(self.latitude.blank? or self.longitude.blank?)
  end

  def add_weight(w)
    if @weight.blank?
      @weight = 0
    end

    @weight = @weight + w
  end

  def is_valid?
    return (self.current_status == "valid" or self.current_status == "valid_unique")
  end

  def save_poi_id(other_id)
    if self.poi_id.blank? and self.poi_id != other_id
      self.poi_id = other_id
      self.current_status = "valid_matched"
      self.save

      return true
    else
      return false
    end
  end

  def hotel_name_alias
    final_text = self.hotel_name.downcase
    final_text = final_text.gsub("'s", " ")
    final_text = final_text.gsub("&", " ")
    final_text = final_text.gsub("-", " ")
    final_text = final_text.gsub(",", " ")
    final_text = final_text.gsub(")", " ")
    final_text = final_text.gsub("(", " ")

    if final_text.include? "formerly"
      final_text = final_text.split("formerly").last
    end

    my_array = final_text.split(" ") - STOP_WORDS
    final_text = my_array.join(" ")

    return StringUtil.clean(final_text)
  end

  def print_description(title = "")
    msg = "#{title} hotel_id:#{self.id}\n"
    msg += "hotel_name:#{self.hotel_name}\n"
    msg += "address:#{self.address}\n"
    msg += "city_name:#{self.city_name}\n"
    msg += "country_name:#{self.country_name}\n"
    msg += "full_address:#{self.full_address}\n"
    msg += "min_rate:#{self.min_rate}\n"
    msg += "hotel_web_url:#{self.hotel_web_url}\n"
    msg += "lat/long:#{self.latitude},#{self.longitude}\n"

    return msg
  end

  def description_cleaned
    if self.hotel_description?
      return StringUtil.remove_double_spaces(self.hotel_description)
    else
      return ""
    end
  end

end
