class MobileController < ApplicationController
  def application_constants
    data = {}
    data[:partner_hotel_remove_header] = '/Mobile/Hotel/Redirection'
  end

  #http://127.0.0.1:3000/mobileupdates/?format=json&country_name=Philippines
  def updates
    #sleep 0
    country = Country.find_by_country_name(params[:country_name] || 'Philippines')

    destinations = destinations_dictionary(country)

    @data = {}
    @data[:front_page] = country_url(country)
    #data[:front_page] = "http://packages.asiatravel.com/packagebooking/tours-attractions.aspx?lan=en-US&scode=RMP77709AU"
    @data[:categories] = country_poi_types(country)
    @data[:buttons] = buttons_from_descriptions(country)
    @data[:top_destinations] = destinations[:top_destinations]
    @data[:destinations] = destinations[:destinations]
    @data[:webview_height] = 300
    @data[:ads] = []

    respond_to do |format|
      format.json
    end
  end

  def country_overview
    @country = Country.find_by_country_name(params[:country_name] || 'Philippines')
  end

  def country_description
    @description = Description.find(params[:id])
  end

  def buttons
    country = Country.find_by_country_name(params[:country_name] || 'Philippines')
    buttonsArray = buttons_from_descriptions(country)

    respond_to do |format|
      format.json { render :json => buttonsArray.to_json }
    end
  end

  def destinations
    country = Country.find_by_country_name(params[:country_name] || 'Philippines')
    data = destinations_dictionary(country)

    respond_to do |format|
      format.json { render :json => data.to_json }
    end
  end

  def adsense
    render :layout => nil
  end

  def register
    result = {}

    if not params[:token].blank?

      if params[:country_name].blank?
        app_id = 103
      else
        app_id = Country.find_by_country_name(params[:country_name]).id
      end

      #token should not have "<" and ">" in the beginning and end of the string
      devices = APN::Device.where(:token => params[:token], :app_id => app_id)
      if devices.empty?
        device = APN::Device.new
        device.app_id = app_id
        device.token = params[:token]
      else
        device = devices.first
      end

      if not (params[:latitude].blank? and params[:longitude].blank?)
        device.latitude = params[:latitude]
        device.longitude = params[:longitude]
      end

      if not params[:profile_id].blank?
        device.profile_id = params[:profile_id]
      end

      if device.save
        result[:valid] = true
        result[:message] = "Thanks for registering with our push notification. We promise not to spam you."
      end
    else
      result[:valid] = false
      result[:message] = "Token Not Provided"
    end

    if not (params[:profile_id].blank? and params[:first_name].blank? and params[:last_name].blank?)
      facebook_users = FacebookUser.where(:profile_id => params[:profile_id])

      if facebook_users.empty?
        user = FacebookUser.new
      else
        user = facebook_users.first
      end

      user.profile_id = params[:profile_id]
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.email = params[:email]
      user.save
    end

    respond_to do |format|
      format.json { render :json => result.to_json }
    end
  end

  private
    def buttons_from_descriptions(country)
      descriptions = country.descriptions

      if !country.description.nil? && country.description.length > 0
        b = {}
        b[:title] = 'Overview'
        b[:path] = mobile_country_overview_url(:country_name => country.name)

        buttonsArray = Array.new
        buttonsArray.push(b)
      end

      for d in descriptions do
        b = {}
        b[:title] = d.description_type.title
        b[:path] = mobile_country_description_url(:id => d.id)
        buttonsArray.push(b)
      end

      buttonsArray
    end

    def destinations_dictionary(country)
      destinations = Destination.select([:id, :destination_name, :total_pois]).where(:country_id => country.id).order(:destination_name)

      destinationsArray = Array.new
      topDestinationsArray = Array.new

      for ds in destinations do
        if ds.total_pois >= 50
          topDestinationsArray.push(ds.destination_name)
        else
          destinationsArray.push(ds.destination_name)
        end
      end

      data = {}
      data[:top_destinations] = topDestinationsArray
      data[:destinations] = destinationsArray

      data
    end

    def country_poi_types(country)
      categories = []

      PoiType.all.each do |poi_type|
        if country.pois.where(:poi_type_name => poi_type.name).count > 0
          categories.push(poi_type.name.pluralize)
        end
      end

      categories
    end
end
