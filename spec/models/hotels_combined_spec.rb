require 'spec_helper'

describe HotelsCombined do

  before(:all) do
    @hc = HotelsCombined.new
  end

  it "should append correctly" do
    @hc.address = "88 Yee Wo Street"
    @hc.city_name = "Hong Kong"
    @hc.full_address_cleaned.should eq "88 Yee Wo Street, Hong Kong"
  end

  it "should clean city_name" do
    @hc.address = "8 Shelter Street Causeway Bay Hong Kong"
    @hc.city_name = "Hong Kong"
    @hc.full_address_cleaned.should eq "8 Shelter Street Causeway Bay Hong Kong"
  end

  it "should have web_partner_url" do
    @hc.hotel_web_url = "http://www.hotelscombined.com/Hotel/Amigo_Terrace_Hotel_Iloilo_City.htm"
    @hc.poi_id = 100063
    @hc.web_partner_url.should eq("http://www.hotelscombined.com/Hotel/Amigo_Terrace_Hotel_Iloilo_City.htm?a_aid=23224&label=100063")
  end

  it "should have mobile_partner_url" do
    @hc.hotel_mobile_url = "http://www.hotelscombined.com/Hotel/Amigo_Terrace_Hotel_Iloilo_City.htm?Mobile=1"
    @hc.poi_id = 100063
    @hc.mobile_partner_url.should eq("http://www.hotelscombined.com/Hotel/Amigo_Terrace_Hotel_Iloilo_City.htm?Mobile=1&a_aid=23224&label=100063")
  end
end

