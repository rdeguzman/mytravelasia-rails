require 'spec_helper'

describe "fetch rates for each provider", :js => true do
  include_context "login"
  include JavascriptHelpers

  before(:each) do
    @poi = Poi.find(102867) #Astoria
  end

  it "should fetch rates for Agoda" do

    login_user(:admin)

    visit poi_path(@poi.id)
    click_link("show_Agoda")
    click_link ("Fetch Rates")

    page.should have_content("Rooms Updated")

    logout_user
  end

  it "should fetch rates for Priceline Booking" do
    login_user(:admin)

    visit poi_path(@poi.id)
    click_link("show_PricelineBooking")
    click_link ("Fetch Rates")

    page.should have_content("Rooms Updated")

    logout_user
  end

  it "should fetch rates for Asia Room", :wip => true do
    login_user(:admin)

    visit poi_path(@poi.id)
    click_link("show_AsiaRoom")
    click_link ("Fetch Rates")

    page.should have_content("Rooms Updated")

    logout_user
  end
end