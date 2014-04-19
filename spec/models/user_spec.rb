require 'spec_helper'

describe User do

  it "should have default normal role" do
    user = User.new
    user.save
    user.role.should == "normal"
  end

  it "should validate email, password, password_confirmation for normal and admin users" do
    user = User.new
    user.valid?.should be_false

    #puts user.errors

    user.errors.has_key?(:email).should be_true
    user.errors.has_key?(:password).should be_true
    #user.errors.has_key?(:password_confirmation).should be_true
  end

  it "should validate if partner" do
    user = User.new
    user.role = "partner"
    user.valid?.should be_false

    #puts user.errors

    user.errors.has_key?(:first_name).should be_true
    user.errors.has_key?(:last_name).should be_true
    user.errors.has_key?(:mobile_no).should be_true
    user.errors.has_key?(:address).should be_true
    user.errors.has_key?(:country_id).should be_true
  end

end

