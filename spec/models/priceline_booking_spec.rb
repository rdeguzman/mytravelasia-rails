require 'spec_helper'

describe PricelineBooking do

  before(:all) do
    @hotel = PricelineBooking.new
  end

  it "has web_partner_url" do
    @hotel.hotel_web_url = "http://www.booking.com/hotel/ph/hayahay-resort.en-us.html"
    @hotel.poi_id = 113499
    @hotel.web_partner_url.should eq("http://www.booking.com/hotel/ph/hayahay-resort.en-us.html?aid=347779&label=113499")
  end

  it "has mobile_partner_url" do
    @hotel.hotel_mobile_url = "http://www.booking.com/hotel/ph/hayahay-resort.en-us.html"
    @hotel.poi_id = 113499
    @hotel.mobile_partner_url.should eq("http://www.booking.com/hotel/ph/hayahay-resort.en-us.html?aid=347779&label=113499")
  end

end

