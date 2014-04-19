class Admin::BookingsController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @bookings = Booking.latest
  end

  def show
    @booking = Booking.find(params[:id])
    @poi = @booking.poi
  end

  def destroy
    booking = Booking.find(params[:id])
    booking.destroy
    flash[:notice] = "Booking was successfully deleted"
    redirect_to admin_bookings_path
  end

end