require 'spec_helper'

describe "User Profile" do
  include_context "login"

  it "should display user" do
    visit root_path

    login_user(:admin)

    page.should have_link("My Profile")

    logout_user
  end

  it "should display profile" do
    user = login_user(:admin)
    visit user_path(user)

    page.should have_content("Full Name")
    page.should have_content("Mobile")
    page.should have_content("Tel")
    page.should have_content("Fax")
    page.should have_content("Address")
    page.should have_content("Country")

    page.should have_link("Edit Profile")

    logout_user
  end

  it "should display edit profile" do
    user = login_user(:admin)
    visit edit_user_path(user)

    page.should have_field("First Name")
    page.should have_field("Last Name")
    page.should have_field("Mobile")
    page.should have_field("Tel")
    page.should have_field("Fax")
    page.should have_field("Address")
    page.should have_select("Country")

    logout_user
  end

  it "should update profile" do
    user = login_user(:admin)
    visit edit_user_path(user)

    fill_in "First Name", :with => "Rupert"
    fill_in "Last Name", :with => "De Guzman"

    click_button("Update Profile")
    page.should have_content("Updated Profile Successfully")
  end

  it "should display show, edit and update for authorized user" do
    different_user = User.find_by_email("rupert@2rmobile.com")
    user = login_user(:partner)

    visit user_path(different_user)
    page.should have_content("Access Denied")

    visit edit_user_path(different_user)
    page.should have_content("Access Denied")

    logout_user
  end

end