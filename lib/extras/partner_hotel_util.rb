module PartnerHotelUtil
  def create_safely(source_hotel, poi)
    if not PartnerHotel.exists?(:partner_type => source_hotel.class.to_s,
                                :poi_id => poi.id,
                                :hotel_id => source_hotel.id)

      partner = PartnerHotel.new
      partner.hotel_id = source_hotel.id
      partner.partner_type = source_hotel.class.to_s
      partner.partner_label = source_hotel.partner_label
      partner.poi_id = poi.id

      partner.hotel_name = source_hotel.hotel_name
      partner.full_address = source_hotel.full_address
      partner.destination_id = poi.destination_id
      partner.country_id = poi.country_id
      partner.description = source_hotel.description_cleaned

      partner.web_partner_url = source_hotel.web_partner_url
      partner.mobile_partner_url = source_hotel.mobile_partner_url

      partner.min_rate = source_hotel.min_rate
      partner.currency_code = source_hotel.currency_code

      partner.latitude = source_hotel.latitude
      partner.longitude = source_hotel.longitude

      partner.save

      puts "Created partner_hotel #{source_hotel.class.to_s}:#{source_hotel.id}"
      return true
    else
      puts "Partner hotel exists"
      return false
    end
  end
end