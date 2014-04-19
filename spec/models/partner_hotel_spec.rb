require 'spec_helper'

describe PartnerHotel do

  it "should set minimum rate if current min rate is higher" do
    partner_hotel = PartnerHotel.new
    partner_hotel.current_min_rate = 100
    partner_hotel.set_current_minimum_rate(95)
    partner_hotel.current_min_rate.should == 95

    partner_hotel.set_current_minimum_rate(200)
    partner_hotel.current_min_rate.should == 95
  end

  it "should have save_rooms" do
    partner_hotel = PartnerHotel.find(1723994) #Asturias Agoda

    rooms = []

    r = {}
    r[:room_type] = "Deluxe"
    r[:price] = "100"
    r[:currency_code] = "USD"
    r[:date_from] = "2012-07-1"
    r[:date_to] = "2012-07-3"

    rooms.push(r)

    expected_rooms = partner_hotel.save_rooms(rooms)
    expected_rooms.count.should == 1
  end

end

