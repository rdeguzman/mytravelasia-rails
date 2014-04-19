require 'spec_helper'

describe "Routes" do

  it "should have country route aliases" do
    Country.all.each do |country|
      country_name = country.name.gsub(" ", "_")
      get("/#{country_name.downcase}").should route_to("countries#show", :id => country.id)
    end
  end

end