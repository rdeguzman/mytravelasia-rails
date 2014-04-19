require 'spec_helper'

describe "Poi Details" do
  before(:each) do
    @poi = Poi.find_by_name("Astoria Boracay Resort")
    visit poi_path(@poi.id)
  end

  it "should display breadcrumbs" do
    page.should have_css("div#breadcrumbs")
  end

  it "should display at least name and address" do
    page.should have_css("h2#poi_name")
    page.should have_css("span#full_address")
  end

  it "should display 'Booking Enquiry'" do
    if @poi.bookable?
      find("div#poi_entry").should have_link("Booking Enquiry")
      page.should have_css("div#booking-enquiry")
    else
      page.should_not have_link("booking_enquiry_button")
      page.should_not have_css("div#booking-enquiry")
    end
  end

  it "should display a 'Map'" do
    if @poi.has_map?
      page.should have_css("div#mapdiv")
    else
      page.should_not have_css("div#mapdiv")
    end
  end

  it "should display nearest 10 pois" do
    if @poi.has_map?
      page.should have_css("div#poi_list")
    else
      page.should_not have_css("div#poi_list")
    end
  end

  it "should display rooms", :wip => true do
    if @poi.poi_type_name == 'Hotel'
      page.should have_link("Check Rates")

      page.should have_css("table#rooms_list")
      find("table#rooms_list").find("thead").should have_content("Room Type")
      find("table#rooms_list").find("thead").should have_content("Currency")
      find("table#rooms_list").find("thead").should have_content("Rate")
      find("table#rooms_list").find("thead").should have_content("Provider")
      find("table#rooms_list").find("thead").should have_content("CheckIn/Out")
    end
  end

end