shared_context "login" do

  def login_user(user_type)

    email = ""

    if user_type.to_sym == :admin
      email = "rndguzmanjr@yahoo.com"
    elsif user_type.to_sym == :normal
      email = "rndguzmanjr@gmail.com"
    elsif user_type.to_sym == :partner
      email = "2rmobiledevs@gmail.com"
    end

    user = User.find_by_email(email)

    visit new_user_session_path
    fill_in "Email", :with => email
    fill_in "Password", :with => "password"
    click_button "Login"

    return user
  end

  def logout_user
    click_link "Logout"
  end

end