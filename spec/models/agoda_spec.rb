require 'spec_helper'

describe Agoda do

  before(:all) do
    @agoda = Agoda.new
  end

  it "should be empty when text Other" do
    @agoda.address = ""
    @agoda.city_name = ""
    @agoda.area_name = "Other"
    @agoda.full_address_cleaned.should eq ""
  end

  it "should clean text with District 1 - Dong Khoi / Nguyen Hue" do
    @agoda.address = ""
    @agoda.city_name = ""
    @agoda.area_name = "District 1 - Dong Khoi / Nguyen Hue"
    @agoda.full_address_cleaned.should eq "Dong Khoi / Nguyen Hue"
  end

  it "should clean address 10 Thai Van Lung St., Ben Nghe ward, District 1, Ho Chi Minh City" do
    @agoda.address = "10 Thai Van Lung St., Ben Nghe ward, District 1, Ho Chi Minh City"
    @agoda.city_name = "Ho Chi Minh City"
    @agoda.area_name = ""
    @agoda.full_address_cleaned.should eq "10 Thai Van Lung St., Ben Nghe ward, District 1, Ho Chi Minh City"
  end

  it "should clean address 174/6 Blue Ocean Studio Pisitkoranee Road, Kathu, Patong, Phuket" do
    @agoda.address = "174/6 Blue Ocean Studio Pisitkoranee Road, Patong, Kathu, Phuket"
    @agoda.area_name = "Patong"
    @agoda.city_name = "Phuket"
    @agoda.full_address_cleaned.should eq "174/6 Blue Ocean Studio Pisitkoranee Road, Kathu, Patong, Phuket"
  end

  it "should clean spaces" do
    @agoda.address = "294/77    30 Kanya Rd. Aumpur Muang"
    @agoda.city_name = ""
    @agoda.area_name = ""
    @agoda.full_address_cleaned.should eq "294/77 30 Kanya Rd. Aumpur Muang"
  end

  it "should clean duplicates in full_address" do
    @agoda.address = "221 Trang Quang Khai St., Tan Dinh Ward, District 1"
    @agoda.area_name = "Tan Dinh - District 1, District 3"
    @agoda.city_name = "Ho Chi Minh City"
    @agoda.full_address_cleaned.should eq "221 Trang Quang Khai St., Tan Dinh Ward, District 1, District 3, Ho Chi Minh City"
  end

  it "should clean only area_name and city_name" do
    @agoda.address = "No.2, Kenting Rd.,"
    @agoda.area_name = "Kenting"
    @agoda.city_name = "Kenting"
    @agoda.full_address_cleaned.should eq "No.2, Kenting Rd., Kenting"
  end

  it "should remove last sentence in description" do
    @agoda.hotel_description = "This is the first sentence. This is the second sentece"
    @agoda.description_cleaned.should eq "This is the first sentence."
  end

  it "should have web_partner_url" do
    @agoda.hotel_web_url = "http://www.agoda.com/asia/philippines/manila/taft_tower_manila.html"
    @agoda.poi_id = 103264
    @agoda.web_partner_url.should eq("http://www.agoda.com/asia/philippines/manila/taft_tower_manila.html?cid=1438344")
  end

  it "should have mobile_partner_url" do
    @agoda.hotel_mobile_url = "http://www.agoda.com/asia/philippines/manila/taft_tower_manila.html"
    @agoda.poi_id = 103264
    @agoda.mobile_partner_url.should eq("http://www.agoda.com/asia/philippines/manila/taft_tower_manila.html?cid=1438344")
  end

end

