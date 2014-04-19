require 'spec_helper'

describe HomeController do
  it "should have featured pois" do
    get :index

    assigns(:pois_featured).should_not be_nil
  end

  it "should have most viewed pois" do
    get :index

    assigns(:pois_most_viewed).should_not be_nil
  end

  it "should have top destinations" do
    get :index

    assigns(:top_destinations).should_not be_nil
  end

  it "should have random attraction" do
    get :index

    assigns(:random_attraction).should_not be_nil
  end

  it "should have random hotel" do
    get :index

    assigns(:random_hotel).should_not be_nil
  end

  it "should have random tour" do
    get :index

    assigns(:random_tour).should_not be_nil
  end

  it "should have random promo" do
    get :index

    assigns(:random_promo).should_not be_nil
  end

end
