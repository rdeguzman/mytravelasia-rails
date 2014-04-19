class BookingsController < ApplicationController

  def new
    @poi = Poi.find(params[:poi_id])
    @booking = Booking.new(@poi)
  end

  def create
    @booking = Booking.create(params[:booking])

    poi_id = params[:booking][:poi_id]
    @booking.poi_id = poi_id
    @poi = Poi.find(poi_id)

    if @booking.save
      SharedMailer.booking_email(@booking).deliver
      redirect_to booking_path(@booking, :poi_id => poi_id), :notice => "Booking enquiry was successfully created."
    else
      render :action => "new", :poi_id => poi_id
    end
  end

  def show
    @poi = Poi.find(params[:poi_id])
  end

  def mobile
    @booking = Booking.create(params[:booking])
    @booking.booking_type = "mobile"

    #remove this when new mobile app is published
    unless params[:comment].blank?
      @booking.comment = params[:comment]
    end

    poi_id = params[:booking][:poi_id]
    @booking.poi_id = poi_id
    @poi = Poi.find(poi_id)

    resp = {}

    if @booking.save
      SharedMailer.booking_email(@booking).deliver
      resp[:message] = "Booking enquiry was successfully created. Thank you for your inquiry. We will get back to you shortly, we usually respond within 24 hours via email at the very least."
      resp[:valid] = true
    else
      resp[:message] = "Unfortunately, we cannot submit your booking enquiry now. Please try again later."
      resp[:valid] = false
    end

    render :json => resp.to_json, :content_type => 'text'
  end

end
