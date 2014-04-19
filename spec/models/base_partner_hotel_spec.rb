require 'spec_helper'

describe BasePartnerHotel do

  it "should remove stop words" do
    hotel = Agoda.new
    hotel.hotel_name = "Swiss-Belhotel Bay View Hotel,Suites and Villas"
    hotel.hotel_name_alias.should eq "swiss belhotel bay view hotel suites villas"
  end

  it "should remove Formerly for PricelineBooking" do
    hotel = PricelineBooking.new
    hotel.hotel_name = "The Sunset Beach Resort & Spa, Taling Ngam (Formerly Ban Sabai Sunset Beach Resort & Spa)"
    hotel.hotel_name_alias.should eq "ban sabai sunset beach resort spa"
  end

  it "should print description for appropriate third party" do
    hotel = Agoda.new
    hotel.id = 1
    hotel.hotel_name = "Test Hotel"
    hotel.full_address = "Some Address"
    hotel.hotel_web_url = "http://path.to.somewhere"
    hotel.latitude =  14.35252
    hotel.longitude =  132.32022

    hotel.print_description.include?("Agoda").should be_true
  end

end

