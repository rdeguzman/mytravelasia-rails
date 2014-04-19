require "spec_helper"

describe "Poi Management" do
  include_context "login"
  include JavascriptHelpers

  describe "Admin" do
    it "should show new and have mandatory fields" do
      login_user(:admin)

      visit new_admin_poi_path
      #save_and_open_page

      page.should have_content("New Poi")

      page.should have_field("Name")
      page.should have_field("Approved")

      page.should have_field("Address")
      page.should have_select("PoiType")
      page.should have_select("Country")
      page.should have_select("Destination")
      page.should have_link("Hide Map")

      logout_user
    end

    it "should update destinations based on country", :js => true do
      login_user(:admin)

      visit new_admin_poi_path
      #save_and_open_page
      poi_name = "TestHotel"
      fill_in "Name", :with => poi_name
      fill_in "Street Address", :with => "1 Infinite Loop, California"
      select "Attraction", :from => "PoiType"

      select "Singapore", :from => "Country"
      wait_for_javascript
      page.has_select?("Destination", :options => ["Singapore"]).should be_true
      page.has_select?("Destination", :options => ["Manila"]).should be_false

      logout_user
    end

    it "should create", :js => true do
      login_user(:admin)

      visit new_admin_poi_path
      #save_and_open_page
      r = Random.new

      poi_name = "TestAttraction #{r.rand(1...100)}"

      fill_in "Name", :with => poi_name
      fill_in "Street Address", :with => "Lalaan 2, Silang"
      select "Philippines", :from => "Country"
      select "Attraction", :from => "PoiType"
      select "Cavite", :from => "Destination"

      click_button "Create Poi"

      page.should have_content(poi_name)
      page.should have_content("Poi Created")
      page.should have_content("Lalaan 2, Silang, Cavite, Philippines")

      page.should have_link("Edit")
      page.should have_link("Delete")
      page.should have_link("Manage")

      poi = Poi.find_by_name(poi_name)
      current_path.include? "#{poi_name}".should be_true
      #save_and_open_page

      logout_user
    end

    it "should update" do
      poi = FactoryGirl.create(:hotel)
      login_user(:admin)

      visit edit_admin_poi_path(poi.id)
      #save_and_open_page

      fill_in "Name", :with => "#{poi.name} Test"

      click_button "Update Poi"
      page.should have_content("Poi Updated")
      #save_and_open_page

      logout_user
    end

    it "should have Edit Approval" do
      poi = Poi.find_by_name("Astoria Boracay Resort")

      login_user(:admin)
      visit poi_path(poi.id)
      page.should have_content("Approval Status:")
      page.should have_link("Edit Approval")
      logout_user
    end
  end


  describe "Partner" do

    it "should not display featured" do
      login_user(:partner)

      click_link("Add Poi(Property/Service)")
      page.should_not have_select("Approved")
      page.should_not have_select("Featured")
      page.should_not have_field("Exclusive")
      all("select#poi_poi_type_id option").should have(6).items

      logout_user
    end

    it "should create a poi but not yet approved and display allowed users" do
      user = login_user(:partner)
      #save_and_open_page

      click_link("Add Poi(Property/Service)")
      poi_name = "TestPartnerHotel"
      fill_in "Name", :with => poi_name
      fill_in "Street Address", :with => "1 Infinite Loop, California"
      select "Philippines", :from => "Country"
      select "Hotel", :from => "PoiType"
      select "Manila", :from => "Destination"

      #save_and_open_page
      click_button "Create Poi"
      page.should have_content("Poi Created")

      poi = Poi.find_by_name("TestPartnerHotel")
      poi.approved.should be_false

      privileges = PoiUserPrivilege.where(:poi_id => poi.id, :user_id => user.id)
      privileges.should have(1).items
      privileges.first.allowed.should be_true

      # check for approval status
      current_path.should include(poi_path(poi.id))
      #save_and_open_page
      find("span#approval").should have_css("img#status_disapproved")
      page.should have_content("Approval Status:")

      # partner who created the poi is already allowed
      page.should have_link("Edit")
      page.should have_link("Manage")
      find("table#allowed_users").should have_content("#{user.full_name}")
      find("table#allowed_users").should have_content("#{user.email}")

      # Allowed Yes or No should be disabled
      find("table#allowed_users").should_not have_link("allow_yes_#{user.id}")
      find("table#allowed_users").should_not have_link("allow_no_#{user.id}")

      # Apply for Ownership
      page.should_not have_content("Are you affiliated with ")
      page.should_not have_link("Apply for Ownership")
      page.should_not have_link("Be a Partner")

      logout_user
    end

    it "should only display Approved if partner is maintainer" do
      poi = Poi.find_by_name("Astoria Boracay Resort")
      visit poi_path(poi.id)

      page.should_not have_content("Approval Status:")

      login_user(:partner)
      visit poi_path(poi.id)
      page.should_not have_link("Edit")
      page.should_not have_content("Approval Status:")
      logout_user
    end

    it "should not be allowed to edit other pois not in PoiUserPrivileges" do
      poi = Poi.find_by_name("Astoria Boracay Resort")

      login_user(:partner)
      visit edit_admin_poi_path(poi.id)
      page.should have_content("You are not authorized to access this page.")
      logout_user
    end

  end

end
