require 'spec_helper'

describe "Destinations" do

  it "should display all destinations for Philippines" do
    country = Country.find_by_country_name("Philippines")
    visit country_destinations_path(country.id)
    #save_and_open_page

    page.should_not have_link("See All Destinations")
  end

end
