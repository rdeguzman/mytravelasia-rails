require "spec_helper"

describe "Poi Ownership" do
  include_context "login"
  include JavascriptHelpers

  it "should display 'Be a Partner' if not logged in" do
    poi = Poi.find_by_name("Astoria Boracay Resort")
    visit poi_path(poi.id)

    find("#poi_ownership").should have_link("Be a Partner")
  end

  it "should display 'Be a Partner' if normal user" do
    poi = Poi.find_by_name("Astoria Boracay Resort")
    visit poi_path(poi.id)

    login_user(:normal)
    visit poi_path(poi.id)
    find("#poi_ownership").should have_link("Be a Partner")

    logout_user
  end

  it "should display 'Apply for Ownership' if partner logged in" do
    poi = Poi.find_by_name("Astoria Boracay Resort")

    login_user(:partner)
    page.should have_link("My Listing")

    visit poi_path(poi.id)
    find("#poi_ownership").should have_link("Apply for Ownership")

    click_link("Apply for Ownership")
    page.should have_content("Request for Ownership successfully submitted.")

    logout_user
  end

  it "should show poi ownership requests for users" do
    login_user(:admin)

    page.should have_link("Poi Ownerships")
    click_link "Poi Ownerships"

    logout_user
  end

end
