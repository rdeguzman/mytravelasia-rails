require 'spec_helper'

describe "Signup" do

  it "should show sign up" do
    visit new_user_registration_path
    page.should have_field("Email")
    page.should have_field("Password")
    page.should have_field("Password Confirmation")
  end

  it "should display Be a Partner" do
    visit root_path
    page.should have_link("Be a Partner")
  end

  it "should display partner registration form" do
    visit new_partner_registration_path
    page.should have_field("First Name")
    page.should have_field("Last Name")
    page.should have_field("Mobile")
    page.should have_field("Tel")
    page.should have_field("Fax")
    page.should have_field("Address")
    page.should have_field("Country")
  end

  it "should validate a new partner" do
    visit new_partner_registration_path
    click_button("Sign Up")

    find("#user_first_name_input").should have_content("can't be blank")
    find("#user_last_name_input").should have_content("can't be blank")
    find("#user_mobile_no_input").should have_content("can't be blank")
    find("#user_address_input").should have_content("can't be blank")
  end

  it "should create a partner and redirect to root" do
    visit new_partner_registration_path

    fill_in "Email", :with => "mytravelasia2012@gmail.com"
    fill_in "Password", :with => "passw0rd"
    fill_in "Password Confirmation", :with => "passw0rd"
    fill_in "First Name", :with => "John"
    fill_in "Last Name", :with => "Smith"
    fill_in "Mobile", :with => "61422515731"
    fill_in "Address", :with => "2 Birkenhead Ave, Wantirna, Vic"
    select "Philippines", :from => "Country"

    click_button("Sign Up")
    page.should have_content("Partner Registration Successful")
    current_path.should == welcome_partner_path

    find("#sidebar_account_header").should have_content("Welcome")
    find("#sidebar_account_links").should have_link("Add Poi(Property/Service)")
  end

end