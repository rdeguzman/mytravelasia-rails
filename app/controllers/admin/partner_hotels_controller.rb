class Admin::PartnerHotelsController < Admin::ApplicationController

  def destroy
    partner_hotel = PartnerHotel.find(params[:id])
    poi = partner_hotel.poi
    partner_hotel.destroy
    flash[:notice] = "Partner Hotel was successfully deleted"
    redirect_to admin_poi_path(poi.id)
  end

  def edit
    @partner_hotel = PartnerHotel.find(params[:id])
    @poi = @partner_hotel.poi
  end

  def update
    @partner_hotel = PartnerHotel.find(params[:id])
    @poi = @partner_hotel.poi

    if @partner_hotel.update_attributes(params[:partner_hotel])
      @partner_hotel.update_source
      flash[:notice] = "PartnerHotel Updated."
      redirect_to poi_path(@poi)
    else
      render :action => 'edit'
    end
  end

  def show
    @partner_hotel = PartnerHotel.find(params[:id])
    @poi = @partner_hotel.poi
    @source_hotel = @partner_hotel.partner_type.constantize.find(@partner_hotel.hotel_id)
    @rooms = @partner_hotel.rooms
  end

  def fetch_rooms
    @partner_hotel = PartnerHotel.find(params[:id])
    source_hotel = @partner_hotel.partner_type.constantize.find(@partner_hotel.hotel_id)

    rooms = source_hotel.fetch_rooms

    unless rooms.empty?
      @partner_hotel.save_rooms(rooms)
      flash[:notice] = "Rooms Updated"
    else
      flash[:notice] = "Rooms Empty"
    end

    redirect_to admin_partner_hotel_path(@partner_hotel.id)
  end

end
