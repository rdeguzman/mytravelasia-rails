require "spec_helper"

describe "PartnerHotel Management", :booking => true do

  before(:each) do
    @poi = Poi.where(:bookable => true).first
    @poi.booking_email_providers = "rndguzmanjr@gmail.com,mytravelasia2012@gmail.com"
    @poi.save
  end

  it "should display booking form" do
    visit poi_path(@poi.id)

    find("#booking-enquiry").should have_content("Booking Enquiry")
    find("#booking-enquiry").should have_field("First Name")
    find("#booking-enquiry").should have_field("Last Name")
    find("#booking-enquiry").should have_field("Contact Number")
    find("#booking-enquiry").should have_field("Email")

    find("#booking-enquiry").should have_field("Rooms")
    find("#booking-enquiry").should have_field("Adults")
    find("#booking-enquiry").should have_field("Children")

    find("#booking-enquiry").should have_field("Arrival")
    find("#booking-enquiry").should have_field("Departure")

    find("#booking-enquiry").should have_field("Comment")
  end

  it "should validate booking form" do
    visit poi_path(@poi.id)
    click_button "Make Booking Enquiry"

    find("#booking_first_name_input").should have_content("can't be blank")
    find("#booking_last_name_input").should have_content("can't be blank")
    find("#booking_contact_no_input").should have_content("can't be blank")
    find("#booking_email_input").should have_content("can't be blank")

    find("#booking_arrival_input").should have_content("can't be blank")
    #find("#booking_departure_input").should have_content("can't be blank")
  end

  it "should create a valid booking" do
    visit poi_path(@poi.id)

    now = Time.now.to_i

    fill_in "First Name", :with => "Rupert"
    fill_in "Last Name", :with => "De Guzman"
    fill_in "Contact Number", :with => "61422515731"
    fill_in "Email", :with => "rndguzmanjr@yahoo.com"

    fill_in "Arrival", :with => "2013-01-01"
    fill_in "Departure", :with => "2013-01-02"

    fill_in "Comment", :with => "#{now} DONT RESPOND. TEST BOOKING ONLY. THIS SHOULD BE DELIVERED TO #{APP_CONFIG[:booking_email_recipients]}"
    #save_and_open_page

    click_button "Make Booking Enquiry"
    #save_and_open_page

    page.should have_content("Booking enquiry was successfully created")

    #puts "Should have email with content #{now}"
  end

end
