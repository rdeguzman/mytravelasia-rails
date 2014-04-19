require "spec_helper"

describe "Picture Management" do
  include_context "login"
  include JavascriptHelpers

  before(:each) do
    login_user(:admin)
    @poi = Poi.find(102555)
  end

  after(:each) do
    logout_user
  end

  it "should show poi and have 'Manage' button", :js => true do
    visit poi_path(@poi.id)
    click_link "Manage"
    #save_and_open_page

    page.should have_link("Cancel")
    page.should have_link("Simple Upload Form")

    page.should have_css("object#picture_imageUploader")
    page.should_not have_link("Edit and Delete Pictures")
    page.should have_link("View Poi")
  end

  it "should test 'Simple Upload Form' and 'Flash Uploader'" do
    visit poi_path(@poi.id)
    click_link "Manage"
    click_link "Simple Upload Form"

    page.should have_button("Upload")

    click_link "Flash Uploader"
    page.should_not have_button("Upload")
  end

  it "should upload using 'Simple Upload Form'", :js => true do
    visit poi_path(@poi.id)
    click_link "Manage"
    click_link "Simple Upload Form"

    attach_file "picture_image", "#{Rails.root}/public/images/test.png"
    click_button "Upload"

    page.should have_content("Picture successfully uploaded.")
    page.should have_link('Make Default')
  end

  it "should upload", :js => true do
    visit poi_path(@poi.id)
    click_link "Manage"

    picture = @poi.pictures.first
    if picture
      click_link "delete_#{picture.id}"
      accept_confirmation_dialog
      page.should have_content("Picture Deleted.")
      current_path.should == admin_pictures_path
    end
  end

  it "should show pictures in admin/pictures" do
    visit poi_path(@poi.id)
    click_link "Manage"

    pictures = @poi.pictures
    unless pictures.empty?
      pictures.each do |p|
        page.should have_content("#{p.image_file_name}")
      end
    end
  end

  it "should edit picture"  do
    visit poi_path(@poi.id)
    click_link "Manage"

    picture = @poi.pictures.first
    if picture
      click_link "edit_#{picture.id}"

      page.should have_field("Title")
      page.should have_field("Description")
      page.should have_field("Credits To")
      page.should have_field("Credits URL")

      #save_and_open_page
    end
  end

end
