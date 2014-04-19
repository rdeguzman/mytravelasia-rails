require 'spec_helper'

describe "Login" do
  include_context "login"

  it "should login and display logout and other links" do
    login_user(:admin)
    page.should_not have_link("Login")
    page.should_not have_link("SignUp")

    page.should have_link("Logout")
    logout_user
  end

  it "should login 'admin' and redirect to the dashboard" do
    login_user(:admin)
    current_path.should == admin_dashboard_path
    logout_user
  end

  it "should login 'admin' and have admin links on the sidebar" do
    login_user(:admin)

    find("#sidebar_account_header").should have_content("Admin")
    find("#sidebar_account_links").should have_link("Admin Home")
    find("#sidebar_account_links").should have_link("Add Country")
    find("#sidebar_account_links").should have_link("Add Destination")
    find("#sidebar_account_links").should have_link("Add Poi")
    find("#sidebar_account_links").should have_link("Add PoiType")
    find("#sidebar_account_links").should have_link("Booking Enquiries")
    find("#sidebar_account_links").should have_link("Feedback")
    find("#sidebar_account_links").should have_link("Users")

    logout_user
  end

  it "should have an 'Admin' " do
    login_user(:admin)
    find("#header-top").should have_link("Admin")
    logout_user

    find("#header-top").should_not have_link("Admin")
  end

  it "should have greeting for non admins" do
    login_user(:normal)

    find("#sidebar_account_header").should have_content("Welcome")
    find("#sidebar_account_links").should have_link("Change Password")

    logout_user
  end

end