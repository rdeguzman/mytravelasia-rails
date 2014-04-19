require 'spec_helper'

describe Poi do

  describe "single attributes" do
    before(:each) do
      @poi = Poi.new
    end

    it "should be bookable if it is not an attraction" do
      @poi.poi_type_name = "Attraction"
      @poi.bookable?.should be_false
    end

    it "should be bookable if bookable is set to true" do
      @poi.bookable = false
      @poi.bookable?.should be_false

      @poi.bookable = true
      @poi.bookable?.should be_true
    end

    it "should not have a rate if 0" do
      @poi.has_rate?.should be_false

      @poi.min_rate = 100
      @poi.currency_code = "USD"

      @poi.has_rate?.should be_true
    end

    it "should not have a rate if null" do
      @poi.min_rate = nil
      @poi.has_rate?.should be_false
    end
  end

  describe "create" do
    it "should have full_address on save" do
      poi = FactoryGirl.create(:attraction)
      poi.full_address.should_not be_nil
      poi.full_address.should eq("123 Rizal Ave, Manila, Philippines")
    end
  end

end

