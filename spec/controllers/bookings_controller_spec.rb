require 'spec_helper'

describe BookingsController do
  it "should create a booking from mobile", :booking => true do
    poi = Poi.where(:poi_type_name => "Hotel").first

    booking = {:poi_id => poi.id,
               :first_name => 'Rupert',
               :last_name => 'De Guzman',
               :contact_no => '0422515731',
               :email => 'rupert@2rmobile.com',
               :rooms => 1,
               :adults => 2,
               :children => 0,
               :arrival => '2011-12-01',
               :departure => '2011-12-04',
               :comment => 'DO NOT REPLY. THIS IS A TEST.'}

    get :mobile, :booking => booking, :comment => booking[:comment]
    response.should be_success
    response.include?("successful")
    assigns(:booking).comment.should eq(booking[:comment])
  end

  it "should update booking#mobile when new mobile app is published, mobile to have booking[:comment] only" do
    1.should eq(0)
  end
end
