require 'spec_helper'

describe "Home Page" do
  it "should display countries in navigation bar" do
    countries = Country.all

    visit root_path

    #save_and_open_page

    countries.each do |country|
      find("div#nav").should have_content(country.name)
    end

  end

  it "should have top destinations on the sidebar" do
    visit root_path
    #save_and_open_page
    find("div#top-destinations").should have_content("Top Destinations")
    find("div#top-destinations").should have_css("li img")
  end

  it "should have featured and most viewed pois" do
    visit root_path
    find("div#pois-organizer").should have_content("Featured")
    find("div#pois-organizer").should have_content("Most Viewed")
  end

  it "should have more links" do
    visit root_path

    ["More Promos", "More Tours", "More Attractions", "More Hotels"].each do |link|
      page.should have_link(link)
    end

  end
end