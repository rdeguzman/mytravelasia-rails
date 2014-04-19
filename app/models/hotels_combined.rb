class HotelsCombined < BasePartnerHotel
  set_table_name "hotels_combineds"

  scope :no_ratings, :conditions => 'number_of_reviews = 0 AND consumer_rating = 0'
  scope :no_rate, :conditions => 'min_rate = 0'

  def name
    self.hotel_name
  end

  def partner_label
    "HotelsCombined"
  end

  def print_description
    super(self.partner_label)
  end

  def full_address_cleaned
    clean_text = ""

    city_name_ = self.city_name
    address_ = self.address

    if not address_.end_with? city_name_
      clean_text = "#{address_}, #{city_name_}"
    else
      clean_text = address_
    end

    clean_text = StringUtil.remove_double_spaces(clean_text)
    return clean_text
  end

  def create_poi
    current = Poi.where(:name => self.name, :address => self.address, :country_name => self.country_name)

    if current.empty?
      poi = Poi.new
      poi.name = self.hotel_name
      poi.address = self.address
      poi.full_address = self.full_address

      poi.longitude = self.longitude
      poi.latitude = self.latitude

      poi.poi_type_id = 2
      poi.poi_type_name = "Hotel"

      poi.description = self.description_cleaned

      poi.current_status = "new"

      poi.total_stars = self.consumer_rating/2
      poi.total_ratings = self.number_of_reviews
      poi.min_rate = self.min_rate
      poi.currency_code = self.currency_code

      unless self.image_id.blank?
        poi.picture_thumb_path = "http://media.hotelscombined.com/HT#{self.image_id}.jpg"
        poi.picture_full_path = "http://media.hotelscombined.com/HI#{self.image_id}.jpg"
      end

      country = Country.find_by_country_name(self.country_name)
      destination = DestinationUtil.find_or_create(self.city_name, country.country_name)

      unless country.blank?
        poi.country_id = country.id
        poi.country_name = country.country_name
      end

      unless destination.blank?
        poi.destination_id = destination.id
        poi.destination_name = destination.name
      end

      poi.save
      puts "Poi(#{poi.id}) created."

      self.poi_id = poi.id
      self.current_status = "valid_matched"
      self.save

      self.create_photos

      return poi

    else

      return current.first

    end

  end

  def create_photos
    unless self.images.blank?

      count = 0

      image_array = self.images.split(",")

      image_array.each do |p|
        WebPhoto.create(
          :thumb_path => "http://media.hotelscombined.com/HT#{p}.jpg",
          :full_path => "http://media.hotelscombined.com/HI#{p}.jpg",
          :poi_id => self.poi_id,
          :user_id => 1
        )

        count += 1
      end

      p = Poi.find(self.poi_id)
      p.total_pictures=count
      p.save

      puts "Created #{count} images"

    end
  end

  def web_partner_url
     if hotel_web_url.include? "?"
       prefix = "&"
     else
       prefix = "?"
     end

    final_url = "#{hotel_web_url}#{prefix}a_aid=#{APP_CONFIG[:hc_a_aid]}&label=#{self.poi_id}"
  end

  def mobile_partner_url
    if hotel_mobile_url.include? "?"
      prefix = "&"
    else
      prefix = "?"
    end

   final_url = "#{hotel_mobile_url}#{prefix}a_aid=#{APP_CONFIG[:hc_a_aid]}&label=#{self.poi_id}"
  end

end

