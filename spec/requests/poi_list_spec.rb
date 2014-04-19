require 'spec_helper'

describe "Poi List" do

  before(:each) do
    visit philippines_path
    click_link("Boracay")
  end

  it "should display poi list" do
    find("#list-info").should have_content("Displaying")
    find("div#sidebar").should have_css("div#mapdiv")
    find("div#main").should have_css("div.flickr_pagination")
  end

  it "should not have Read More" do
    page.should_not have_content("Read More")
  end

end