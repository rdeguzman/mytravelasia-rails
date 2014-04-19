require 'spec_helper'

describe RemotePartnerHotel do
  # should have 127.0.0.1:3000 running
  it "should have Rooms Updated" do
    partner_hotel = PartnerHotel.find(1723994) #Asturias Agoda

    rooms = []

    r = {}
    r[:room_type] = "Deluxe"
    r[:price] = "100"
    r[:currency_code] = "USD"
    r[:date_from] = "2012-07-1"
    r[:date_to] = "2012-07-3"

    rooms.push(r)

    remote_partner = RemotePartnerHotel.new
    response = remote_partner.post(partner_hotel.id, rooms)
    #puts response.body, response.code, response.message, response.headers.inspect

    response.code.should == 200
    response.message.strip.should == "OK"
    response.body.should == "Rooms Updated"

    expected_rooms = Room.where(:partner_hotel_id => partner_hotel.id, :hotel_id => partner_hotel.hotel_id)
    expected_rooms.count.should == 1
    #pp expected_rooms
  end

  it "should have Rooms Empty" do
    partner_hotel = PartnerHotel.find(1723994) #Asturias Agoda

    rooms = []

    remote_partner = RemotePartnerHotel.new
    response = remote_partner.post(partner_hotel.id, rooms)
    #puts response.body, response.code, response.message, response.headers.inspect

    response.code.should == 200
    response.message.strip.should == "OK"
    response.body.should == "Rooms Empty"
  end


end

