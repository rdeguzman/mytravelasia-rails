class PartnerHotel < ActiveRecord::Base
  attr_accessible :id, :hotel_file_name, :hotel_name, :rating,
                  :destination_id, :country_id, :address, :min_rate,
                  :image_file_name, :currency_code, :longitude, :latitude,
                  :number_of_reviews, :consumer_rating, :property_type_id,
                  :chain_id, :facility_list_id, :poi_id

  belongs_to :poi
  belongs_to :destination
  belongs_to :country
  has_many :rooms

  attr_accessor :current_min_rate

  scope :has_poi, :conditions => 'poi_id is not null'

  def self.exists?(obj={})
    !self.where("partner_type = :partner_type AND poi_id = :poi_id AND hotel_id = :hotel_id", obj).empty?
  end

  def update_source
    source_hotel = self.partner_type.constantize.find(self.hotel_id)
    source_hotel.poi_id = self.poi_id
    source_hotel.current_status = "valid_manual"
    source_hotel.save
  end

  def currency_min_rate
    "#{self.currency_code} #{self.min_rate}"
  end

  def set_current_minimum_rate(rate)
    begin
      if self.current_min_rate.blank?
        self.current_min_rate = rate.to_f
      elsif rate.to_f < self.current_min_rate.to_f
        self.current_min_rate = rate
      end
    rescue Exception => e
      logger.info("set_current_minimum_rate error")
      logger.info(e.backtrace)
    end
  end

  def save_rooms(rooms=[])
    rooms_added = []

    Room.where(:partner_hotel_id => self.id, :hotel_id => self.hotel_id).destroy_all

    rooms.each do |room|
      r = Room.new
      r.partner_hotel_id = self.id
      r.hotel_id = self.hotel_id
      r.partner_type = self.partner_type
      r.room_type = room[:room_type]
      r.rate = room[:price]
      r.currency_code = room[:currency_code]
      r.date_from = room[:date_from]
      r.date_to = room[:date_to]
      r.save

      rooms_added.push(r)

      self.currency_code = room[:currency_code]
      self.set_current_minimum_rate(room[:price])
    end

    self.min_rate = self.current_min_rate
    self.save

    p = self.poi
    p.min_rate = self.current_min_rate
    p.currency_code = "USD"
    p.save

    return rooms_added
  end

end
