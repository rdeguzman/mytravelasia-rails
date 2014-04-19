class RemotePartnerHotel
  include HTTParty
  base_uri "#{APP_CONFIG[:room_api]}"

  def initialize()

  end

  def post(partner_hotel_id, rooms=[])
    options = {:body => { :rooms => rooms } }
    self.class.post("/partner_hotels/#{partner_hotel_id}/save_rooms", options)
  end
end