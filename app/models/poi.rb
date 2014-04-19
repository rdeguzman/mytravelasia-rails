class Poi < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  attr_accessible :id, :name, :address, :tel_no, :web_url, :email, :longitude, :latitude,
                  :destination_id, :destination_name,
                  :country_id, :country_name,
                  :description,
                  :poi_type_id, :poi_type_name,
                  :total_stars, :total_ratings, :total_views, :total_likes,
                  :featured, :bookable, :exclusive, :booking_email_providers,
                  :approved

  attr_accessor :last_viewed
  cattr_accessor :skip_callbacks

  has_many :poi_user_privileges
  has_many :users, :through => :poi_user_privileges
  has_many :likes

  belongs_to :destination
  belongs_to :country
  belongs_to :poi_type

  has_many :comments
  
  has_many :descriptions, :foreign_key => 'parent_id', :conditions => "table_name = 'poi'"
  has_many :pictures, :dependent => :destroy
  accepts_nested_attributes_for :pictures
  #accepts_nested_attributes_for :pictures, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].nil? }
  
  has_many :web_photos, :dependent => :destroy
  has_many :partner_hotels

  before_save :specify_country,
              :specify_destination,
              :specify_poi_type,
              :update_full_address,
              :unless => :skip_callbacks
  
  validates :name, :presence => true
  validates :address, :presence => true
  
  validates :country, :presence => true
  validates :destination, :presence => true
  validates :poi_type, :presence => true

  scope :with_pictures, :conditions => 'total_pictures > 0'
  scope :with_description, :conditions => 'description is not null'
  scope :with_gps, :conditions => 'latitude is not null OR latitude != 0 OR longitude is not null OR longitude != 0'

  scope :attraction, :conditions => { :poi_type_name => :attraction}
  scope :hotel, :conditions => { :poi_type_name => :hotel}
  scope :tour, :conditions => { :poi_type_name => :tour}
  scope :promo, :conditions => { :poi_type_name => :promo}

  scope :latest, :order => "updated_at DESC"
  scope :latest_viewed, :order => "viewed_at DESC"
  scope :featured, :conditions => { :featured => true}
  scope :most_viewed, :order => "total_views DESC"
  scope :random, :order => "RAND()"

  scope :exclusive, :conditions => {:exclusive => true}

  scope :currently_valid, :conditions => { :poi_type_name => :hotel}
  scope :only_approved, :conditions => {:approved => true}

  define_index do
    indexes :name
    #indexes [:name, :address, :destination_name, :country_name], :as => :name_location
    indexes [:name, :address, :destination_name, :country_name], :as => :name_location
    #where 'latitude is not null AND latitude is not null'

    has "CAST(IF(latitude is null or longitude is null or latitude = 0 or longitude = 0, 0, 1) AS UNSIGNED)", :type => :integer, :as => :geocoded
    has "CAST(approved AS UNSIGNED)", :type => :integer, :as => :approved
    has "RADIANS(latitude)", :as => :lat, :type => :float
    has "RADIANS(longitude)", :as => :lon, :type => :float
    has country_id
    has poi_type_id
  end
  
  def to_param
    "#{id}-#{name.gsub(/\s/, '-').gsub(/[^0-9A-Za-z\-]/, '')}"
  end

  def has_map?
    if self.latitude.nil? || self.longitude.nil?
      false
    else
      true
    end
  end

  def has_photos?
    if self.total_pictures > 0
      true
    else
      false
    end
    #unless self.pictures.blank? && self.web_photos.blank?
    #  true
    #else
    #  false
    #end
  end

  def has_more_photos?
    unless self.pictures.blank? && self.web_photos.blank?
      if self.pictures.count > 1 or self.web_photos.count > 1
        true
      else
        false
      end
    else
      false
    end
  end

  def update_total_views
    Poi.skip_callbacks = true
    Poi.record_timestamps = false
    self.total_views = self.total_views + 1
    self.last_viewed = self.viewed_at
    self.viewed_at = Time.now
    self.save(:validate => false)
    Poi.skip_callbacks = false
    Poi.record_timestamps = true
  end

  def bookable?
    if self.poi_type_name == "Attraction" then
      false
    else
      if self.bookable == 1 || self.bookable == true
        true
      else
        false
      end
    end
  end

  def default_picture_full_path
    if self.has_photos?
      if self.picture_full_path.blank?
        return "no-image.png"
      else
        return self.picture_full_path
      end
    else
      return "no-image.png"
    end
  end

  def print_description
    puts "POI name:#{self.name}"
    puts "address:#{self.address}"
    puts "lat/long:#{self.latitude},#{self.longitude}"
  end

  def has_rate?
    if self.currency_code? and self.min_rate?
      if self.min_rate > 0
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def needs_higher_resolution?
    if self.poi_type_name == "Travel Guide" or self.poi_type_name == "Brochure"
      return true
    else
      return false
    end
  end

  def full_address_cleaned
    clean_text = ""

    destination_name_ = self.destination_name
    country_name_ = self.country_name
    address_ = self.address

    if not address_.end_with? destination_name_
      clean_text = "#{address_}, #{destination_name_}"
    else
      clean_text = address_
    end

    if not address_.end_with? country_name_
      clean_text = "#{clean_text}, #{country_name_}"
    else
      clean_text = address_
    end

    clean_text = StringUtil.remove_double_spaces(clean_text)
    return clean_text
  end

  def default_picture(style, default)
    if self.has_pictures?
      self.pictures.first.image.url(style)
    else
      self[default]
    end
  end

  def has_pictures?
    return !(self.pictures.empty?)
  end

  def maintained_by?(user)
    if user.blank?
      return false
    else
      if user.admin?
        return true
      elsif user.partner?
        privileges = PoiUserPrivilege.where(:user_id => user.id,
                                            :poi_id => self.id)
        return !privileges.empty?
      else
        return false
      end
    end
  end

  def allowed_and_maintained_by?(user)
    if user.blank?
      return false
    else
      if user.admin?
        return true
      elsif user.partner?
        privileges = PoiUserPrivilege.where(:user_id => user.id,
                                            :poi_id => self.id,
                                            :allowed => true)
        return !privileges.empty?
      else
        return false
      end
    end
  end

  def ownership_request_empty?(user)
    privileges = PoiUserPrivilege.where(:user_id => user.id,
                                        :poi_id => self.id)
    return privileges.empty?
  end

  #def update_picture_count
  #  pics = self.pictures
  #  photos = self.web_photos
  #  total_images = pics.count + photos.count
  #
  #  if total_images > 0
  #    if pics.count > 0
  #      thumb_path = pics.first.image.url(:thumb)
  #      full_path = pics.first.image.url(:square)
  #    else
  #      thumb_path = photos.first.thumb_path
  #      full_path = photos.first.full_path
  #    end
  #
  #    self.total_pictures = total_images
  #    self.picture_thumb_path = thumb_path
  #    self.picture_full_path = full_path
  #  else
  #    self.total_pictures = 0
  #    self.picture_thumb_path = ""
  #    self.picture_full_path = ""
  #  end
  #end

  def partner_poi_types
    PoiType.where(:poi_type_name => ["Attraction", "Car Rental", "Event", "Hotel", "Restaurant", "Tour",])
  end

  def likes_count
    self.likes.count
  end

  def update_likes
    self.total_likes = self.likes_count
    self.save
  end

  def liked_it(profile_id)
    likes = Like.where(:profile_id => profile_id, :poi_id => self.id)
    if likes.size > 0
      true
    else
      false
    end
  end

  def notify_users(owner_id, content)
    commenter = FacebookUser.find(owner_id)

    alert_text = '"' + truncate(content, :length => 70) + '"' + " by #{commenter.first_name} on #{truncate(self.name, :length => 25)}"

    likes_array = self.likes.where('profile_id <> ?', owner_id)
    profile_ids = likes_array.collect{|c| c.profile_id}
    
    devices = APN::Device.where(:profile_id => profile_ids.uniq,
                                :app_id => self.country_id)

    unless devices.empty?

      devices.each do |dev|
        n = APN::Notification.new
        n.device = dev
        n.sound = true
        #truncate the content to 100 characters
        n.alert = alert_text
        n.save
      end

      # By sending each apn when its inserted it becomes very slow
      # Run rake task instead
      # APN::App.send_notifications
    end

    comments_array = self.comments.where('profile_id <> ?', owner_id)
    email_profile_ids = comments_array.collect{|c| c.profile_id}

    email_profile_ids.push(593094999) #rupert:rndguzmanjr@yahoo.com
    email_profile_ids.push(633633383) #caloy:pinoytourist@gmail.com
    #logger.info("email_profile_ids: #{email_profile_ids}")

    facebook_users = FacebookUser.where(:profile_id => email_profile_ids.uniq).where('email is not null')
    unless facebook_users.empty?
      if facebook_users.size <= 5
        facebook_users.each do |fb_user|
          SharedMailer.mobile_comment_email(commenter, fb_user, content, self.id, self.name).deliver
        end
      end
    end

  end

  private
    def specify_country
      country = Country.find(self.country_id)
      self.country_name = country.country_name
    end
    
    def specify_destination
      destination = Destination.find(self.destination_id)
      self.destination_name = destination.destination_name
    end

    def specify_poi_type
      poi_type = PoiType.find(self.poi_type_id)
      self.poi_type_name = poi_type.poi_type_name
    end
    
    #disable this during rake task
    def update_full_address
      self.full_address = self.full_address_cleaned
    end

end
