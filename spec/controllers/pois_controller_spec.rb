require 'spec_helper'

describe PoisController do

  describe "web" do
    it "should show" do
      poi = Poi.find(102586)
      get :show, :id => poi.id
      response.should be_success

      assigns(:poi).should_not be_nil
      assigns(:descriptions).should_not be_nil

      assigns(:pictures).should_not be_nil
      assigns(:web_photos).should_not be_nil

      if poi.has_map?
        assigns(:pois).should_not be_nil
      else
        assigns(:pois).should be_nil
      end

    end
  end


  #it "search results should return all records if no country_name is given" do
  #  get :search, :keyword => 'days hotel'
  #
  #  assigns(:pois).count.should == 9
  #end
  #
  #it "search results should return only records in Philippines if country_name is given" do
  #  get :search, :keyword => 'days hotel', :country_name => 'Philippines', :page => 1
  #
  #  assigns(:pois).count.should == 6
  #end
  #
  #it "search results should return only records in Philippines if country_name is included in the keyword" do
  #  get :search, :keyword => 'days hotel philippines', :page => 1
  #
  #  assigns(:pois).count.should == 6
  #end
  #
  #it "search results should return distance if longitude and latitude is given" do
  #  get :search, :keyword => 'days hotel', :country_name => 'Philippines', :latitude => '14.550298', :longitude => '121.029475', :format => 'json', :page => 1
  #
  #  response.body.to_s.index('"data"').should_not be nil
  #  response.body.to_s.index('"distance"').should_not be nil
  #  response.body.to_s.index('"total_pages"').should_not be nil
  #end
  #
  #it "search results should not return records without longlats" do
  #  get :search, :keyword => 'Matalinga Island', :country_name => 'Philippines', :latitude => '14.550298', :longitude => '121.029475', :format => 'json', :page => 1
  #
  #  response.body.to_s.index('"data"').should_not be nil
  #  response.body.to_s.index('"distance"').should be nil
  #  response.body.to_s.index('"total_pages"').should_not be nil
  #  response.body.to_s.index('[]').should_not be nil
  #  response.body.to_s.should == '{"data":[],"total_pages":0}'
  #end
  #
  #it "recent results should not return records without longlats" do
  #  get :recent, :country_name => 'Singapore', :format => 'json', :page => 1
  #
  #  response.body.to_s.index('"data"').should_not be nil
  #  response.body.to_s.index('"total_pages"').should_not be nil
  #  response.body.to_s.index('"longitude":null').should be nil
  #end
end
