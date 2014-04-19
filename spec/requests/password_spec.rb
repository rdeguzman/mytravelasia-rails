require 'spec_helper'

describe "Password" do
  include_context "login"

  it "should display forgot your password page" do
    visit root_path
    click_link "Login"
    click_link "Forgot your password?"
    page.should have_content("Forgot your password?")
    page.should have_field("Email")
  end

  it "should display edit password for user" do
    login_user(:normal)

    click_link("Change Password")
    page.should have_field("New Password")
    page.should have_field("Password Confirmation")

    logout_user
  end

  it "should validate password for user" do
    login_user(:normal)

    click_link("Change Password")
    click_button("Update Password")

    page.should have_content("can't be blank")

    fill_in "New Password", :with => "pa$$w0rd"
    fill_in "Password Confirmation", :with => "Pa$$w0rd"
    click_button("Update Password")

    page.should have_content("doesn't match confirmation")

    logout_user
  end



end