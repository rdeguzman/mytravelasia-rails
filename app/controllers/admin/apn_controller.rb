class Admin::ApnController < Admin::ApplicationController

  def devices
    @total_records = APN::Device.count
    @devices = APN::Device.order('created_at desc').paginate(:per_page => 10, :page => params[:page])
  end

  def new
    app_ids = APN::App.all.collect{|a| a.id}
    @countries = Country.where(:id => app_ids).order('country_name')
  end

  def create
    devices = APN::Device.where(:app_id => params[:apn][:app_id])
    devices.each do |device|
      n = APN::Notification.new
      n.badge = params[:apn][:badge]
      n.sound = params[:apn][:sound]
      n.alert = params[:apn][:alert]
      n.device = device
      n.save
    end

    redirect_to admin_apn_notifications_path
  end

  def notifications
    @notifications = APN::Notification.paginate(:per_page => 10, :page => params[:page])
  end

  def destroy
    notification = APN::Notification.find(params[:id])
    notification.destroy
    redirect_to admin_apn_notifications_path
  end

end