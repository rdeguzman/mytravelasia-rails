require 'spec_helper'

describe CountriesController do
  before(:all) do
    @philippines = Country.find_by_country_name("Philippines")
    @thailand = Country.find_by_country_name("Thailand")
  end

  it "should have country" do
    get :show, :id => @philippines.id
    assigns(:country).should_not be_nil
  end

  it "should have featured pois" do
    get :show, :id => @philippines.id
    assigns(:pois_featured).should_not be_nil
  end

  it "should have most viewed pois" do
    get :show, :id => @philippines.id
    assigns(:pois_most_viewed).should_not be_nil
  end

  it "should have top destinations" do
    get :show, :id => @philippines.id
    assigns(:top_destinations).should_not be_nil
  end

  it "should have all destinations" do
    get :show, :id => @philippines.id
    assigns(:all_destinations).should_not be_nil
  end

  it "should have at least an attraction" do
    get :show, :id => @philippines.id
    assigns(:random_attraction).should_not be_nil
  end

  it "should have at least a hotel" do
    get :show, :id => @philippines.id
    assigns(:random_hotel).should_not be_nil
  end

  it "should have optional tour" do
    get :show, :id => @philippines.id
    assigns(:random_tour).should_not be_nil

    get :show, :id => @thailand.id
    assigns(:random_tour).should be_nil
  end

  it "should have optional promo" do
    get :show, :id => @philippines.id
    assigns(:random_promo).should_not be_nil

    get :show, :id => @thailand.id
    assigns(:random_promo).should be_nil
  end

  it "should have country descriptions" do
    get :show, :id => @philippines.id
    assigns(:country_descriptions).should_not be_nil
  end


end