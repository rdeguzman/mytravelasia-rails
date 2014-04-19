class SharedMailer < ActionMailer::Base
  def support_email(support)
    @support = support
    mail(:to => "#{APP_CONFIG[:admin_email]}",
         :subject => "Feedback",
         :from => support.email)
  end

  def booking_email(booking)
    @booking = booking
    @poi = @booking.poi
    mail(:to => "#{@poi.booking_email_providers}",
         :bcc => "#{APP_CONFIG[:booking_email_recipients]}",
         :subject => "MyTravelAsia Reservation Enquiry #{booking.id} from #{booking.full_name}",
         :from => "#{booking.email}",
         :reply_to => "#{booking.email}")
  end

  def registration_successful_email(user)
    @user = user
    mail(:to => user.email,
         :subject => "Partner Registration from mytravel-asia.com",
         :from => "support@mytravel-asia.com" )
  end

  def ownership_request_confirmation_email(user_id, poi_id)

    @user = User.find(user_id)
    @poi = Poi.find(poi_id)

    mail(:to => @user.email,
         :bcc => "#{APP_CONFIG[:admin_email]}",
         :subject => "Ownership Request for #{@poi.name}",
         :from => "support@mytravel-asia.com" )
  end

  def ownership_allowed_confirmation_email(user_id, poi_id, allowed)
    @user = User.find(user_id)
    @poi = Poi.find(poi_id)
    @allowed = allowed

    mail(:to => @user.email,
         :bcc => "#{APP_CONFIG[:admin_email]}",
         :subject => "Ownership Confirmation for #{@poi.name}",
         :from => "support@mytravel-asia.com" )
  end

  def mobile_comment_email(commenter, fb_user, content, poi_id, poi_name)
    @commenter = commenter
    @fb_user = fb_user
    @content = content
    @poi_id = poi_id
    @poi_name = poi_name
    mail(:to => @fb_user.email,
         :subject => "#{@commenter.first_name} commented on #{poi_name}",
         :from => "support@mytravel-asia.com" )
  end

end
