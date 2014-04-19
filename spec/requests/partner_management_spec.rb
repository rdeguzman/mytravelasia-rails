require "spec_helper"

describe "PartnerHotel Management" do
  include_context "login"
  include JavascriptHelpers

  before(:each) do
    @partner_hotel = PartnerHotel.where(:partner_type => "Agoda", :country_id => Country.find_by_country_name("Philippines").id).first
    @poi = @partner_hotel.poi
  end

  it "should display show and delete in poi/show" do
    login_user(:admin)

    visit poi_path(@poi.id)

    page.should have_link("show_Agoda")
    page.should have_link("delete_Agoda")

    logout_user
  end

  it "should display show" do
    login_user(:admin)

    visit poi_path(@poi.id)

    click_link("show_Agoda")

    page.should have_link("edit_Agoda")

    page.should have_content("Web Partner URL")
    page.should have_content("Mobile Partner URL")
    page.should have_content("Minimum Rate")

    page.should have_link("Fetch Rates")

    page.should have_content("Rooms")

    logout_user
  end

  it "should display edit" do
    login_user(:admin)

    visit edit_admin_partner_hotel_path(@partner_hotel.id)
    current_path.should == edit_admin_partner_hotel_path(@partner_hotel.id)

    page.should have_field("Poi ID")
    #save_and_open_page

    logout_user
  end

  it "should update poi_id" do
    login_user(:admin)

    visit edit_admin_partner_hotel_path(@partner_hotel.id)
    fill_in "Poi ID", :with => "119909"
    click_button "Update Partner Hotel"
    page.should have_content("PartnerHotel Updated")

    logout_user
  end

end
