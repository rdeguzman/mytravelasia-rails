class PartnerHotelsController < ApplicationController
  def check_rates
    poi = Poi.find(params[:id])

    partner_hotels = PartnerHotel.where(:poi_id => params[:id]).where("partner_type != 'HotelsCombined'")

    @rooms = []

    partner_hotels.each do |partner_hotel|
      source_hotel = partner_hotel.partner_type.constantize.find(partner_hotel.hotel_id)

      rooms = source_hotel.fetch_rooms(params[:check_in], params[:check_out])

      tokens_check_in = params[:check_in].split("-")
      tokens_check_out = params[:check_out].split("-")
      start_date = Time.new(tokens_check_in[0], tokens_check_in[1], tokens_check_in[2], 12, 0, 0)
      end_date = Time.new(tokens_check_out[0], tokens_check_out[1], tokens_check_out[2], 12, 0, 0)

      unless rooms.empty?

        new_rooms = partner_hotel.save_rooms(rooms)
        new_rooms.each do |r|
          @rooms.push(r)
        end

      end

    end

    respond_to do |format|
      format.html{ redirect_to poi_path(poi.id) }
      format.json{ render :partial => "rooms.json"}
    end

  end

  def save_rooms
    rooms = params[:rooms] || []
    partner_hotel = PartnerHotel.find(params[:id])

    unless rooms.empty?
      partner_hotel.save_rooms(rooms)

      render :text => "Rooms Updated"
    else
      render :text => "Rooms Empty"
    end

  end
end