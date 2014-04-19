require 'spec_helper'

describe AsiaRoom do

  before(:all) do
    @asia_room = AsiaRoom.new
  end

  it "should clean" do
    @asia_room.address = "566/1 Patak Road, Karon Beach, Muang, Phuket, 83100 Thailand"
    @asia_room.city_name = "Phuket"
    @asia_room.country_name = "Thailand"
    @asia_room.full_address_cleaned.should eq "566/1 Patak Road, Karon Beach, Muang, Phuket, 83100"
  end

  it "should clean" do
    @asia_room.address = "124/29 Moo#3 Tumbon Cheung Thalay Thalang, Phuket Thailand 83110."
    @asia_room.city_name = "Phuket"
    @asia_room.country_name = "Thailand"
    @asia_room.full_address_cleaned.should eq "124/29 Moo#3 Tumbon Cheung Thalay Thalang, Phuket 83110."
  end

  it "should clean" do
    @asia_room.address = "266 Prabaramee Road, Patong Beach, Kathu,"
    @asia_room.city_name = "Phuket"
    @asia_room.country_name = "Thailand"
    @asia_room.full_address_cleaned.should eq "266 Prabaramee Road, Patong Beach, Kathu, Phuket"
  end

  it "should have web_partner_url" do
    @asia_room.hotel_web_url = "http://www.asiarooms.com/en/thailand/bangkok/176326-samran_place.html"
    @asia_room.web_partner_url.should eq("http://www.asiarooms.com/en/p/12962/thailand/bangkok/176326-samran_place.html?pv=aff12962_text&utm_source=aff_mytravelasia&utm_campaign=aff12962&utm_medium=affiliates&utm_content=text")
  end

  it "should have mobile_partner_url" do
    @asia_room.hotel_mobile_url = "http://www.asiarooms.com/en/thailand/bangkok/176326-samran_place.html"
    @asia_room.mobile_partner_url.should eq("http://www.asiarooms.com/en/p/12962/thailand/bangkok/176326-samran_place.html?pv=aff12962_text&utm_source=aff_mytravelasia&utm_campaign=aff12962&utm_medium=affiliates&utm_content=text")
  end
end

