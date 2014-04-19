require 'spec_helper'

describe "Countries" do
  it "should display top destinations" do
    countries = Country.where(:country_name => ["Philippines"])

    countries.each do |country|
      visit country_path(country.id)
      #save_and_open_page

      find("div#top-destinations").should have_content("Top Destinations")
      find("div#top-destinations").should_not have_css("li img")
    end
  end

  it "should have at least 4 minimum attractions/featured for a country" do
    countries = Country.all


    countries.each do |country|
      visit country_path(country.id)
      #save_and_open_page

      find("div#pois-organizer").should have_content("Featured"), :message => "#{country.name} should have Featured"
      find("div#pois-organizer").should have_content("Most Viewed"), :message => "#{country.name} should have Most Viewed"

      ["More Attractions","More Hotels"].each do |link|
        page.should have_link(link), :message => "#{country.name} should have #{link}"
      end
    end
  end

  it "should display 'See All Destinations'" do
    country = Country.find_by_country_name("Philippines")
    visit country_path(country)
    page.should have_link("See All Destinations")

    country = Country.find_by_country_name("Singapore")
    visit country_path(country)
    page.should_not have_link("See All Destinations")
  end

end