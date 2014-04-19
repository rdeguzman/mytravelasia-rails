class PoisController < ApplicationController
  include ActionView::Helpers::NumberHelper

  #http://127.0.0.1:3000/pois/102758?format=json => Patio Pacific JSON
  def show
    pois = Poi.includes(:country, :destination, :pictures, :web_photos, :comments).where(:id => params[:id])

    if pois.empty?
      @reason = "Poi does not exist anymore"
      render :template => "/errors/404.html.erb", :status => 404
      return
    else
      @poi = pois.first
    end

    @descriptions = @poi.descriptions
    @pictures = @poi.pictures
    @web_photos = @poi.web_photos
    
    if params[:format] == 'json'

      # Update total views if requested from device
      @poi.update_total_views

      # Find if user_agent is from iphone;, ipad;
      find_user_agent

      if @poi.poi_type_name == 'Hotel'
        @partner_hotels = PartnerHotel.where(:poi_id => @poi.id).all
        @rooms = find_rooms(@partner_hotels)
      end

    else

      if @poi.poi_type_name == 'Hotel'
        @partner_hotels = PartnerHotel.where(:poi_id => @poi.id).all
      end

      if @poi.bookable?
        @booking = Booking.new(@poi)
      end

      if @poi.has_map?
        @pois = find_nearby(@poi.country_id, @poi.latitude, @poi.longitude)
      end

    end

    respond_to do |format|
      format.html { current_navigation @poi.country_name.parameterize.underscore.to_sym }
      format.json
    end
  end

  #http://127.0.0.1:3000/search?format=json&country_name=Philippines&keyword=rizal park&latitude=14.535904&longitude=120.984970
  def search
    keywords = params[:keyword] || ""
  
    search_options = { :page => params[:page] || 1, :per_page => 10 }
          
    @current_latitude = params[:latitude] || 0 #14.651499
    @current_longitude = params[:longitude] || 0 #121.049322

    if @current_latitude.to_f > 0 && @current_longitude.to_f > 0
      search_options.merge!( :geo => [degrees_to_radians(@current_latitude.to_f), degrees_to_radians(@current_longitude.to_f)] , :order => "@geodist ASC, @relevance DESC" )
    else
      search_options.merge!( :order => "@relevance DESC" )
    end

    if params[:format] == 'json'
      search_options.merge!( :without => { :geocoded => 0, :approved => 0 } )
    else
      search_options.merge!( :without => { :approved => 0 } )
    end

    unless params[:country_name].blank?
      country = Country.find_by_country_name(params[:country_name])
      search_options.merge!( :with => { :country_id => country.id } )
    end

    unless params[:poi_type_name].blank?
      poi_type_id = PoiType.where(:poi_type_name => params[:poi_type_name].singularize).first.id
      search_options.merge!( :with => { :poi_type_id => poi_type_id })
    end
          
    @pois = Poi.search(keywords, search_options)
    render_results @pois
  end

  #http://127.0.0.1:3000/nearby?country_name=Philippines&latitude=14.550298&longitude=121.029475&format=json&page=1
  def nearby
    country = Country.find_by_country_name(params[:country_name] || "Philippines")

    current_latitude = params[:latitude] || 0 #14.651499
    current_longitude = params[:longitude] || 0 #121.049322

    @pois = find_nearby(country.id, current_latitude, current_longitude)
    render_results @pois
  end

  #http://127.0.0.1:3000/recent?format=json&country_name=Philippines&page=1
  def recent
    _pois = get_poi_list_by_country_and_or_poi_type_name.latest
    paginate_and_render_results _pois
  end

  def featured
    _pois = get_poi_list_by_country_and_or_poi_type_name.featured
    paginate_and_render_results _pois
  end

  def most_viewed
    _pois = get_poi_list_by_country_and_or_poi_type_name.most_viewed
    paginate_and_render_results _pois
  end

  def like
    like = Like.new
    like.profile_id = params[:profile_id]
    like.poi_id = params[:id]

    if like.save
      poi = like.poi
      poi.update_likes
    else
      poi = Poi.find(params[:id])
    end

    result = {}
    result[:poi_id] = poi.id
    result[:likes] = poi.likes_count
    result[:liked] = true

    respond_to do |format|
      format.json {render :text => result.to_json}
    end
  end

  def unlike
    like = Like.where(:profile_id => params[:profile_id], :poi_id => params[:id])
    poi = Poi.find(params[:id])

    if like.size > 0
      l = like.first
      l.destroy
      poi.update_likes
    end

    result = {}
    result[:poi_id] = params[:id]
    result[:likes] = poi.likes_count
    result[:liked] = false

    respond_to do |format|
      format.json {render :text => result.to_json}
    end
  end

  #http://127.0.0.1:3000/feed.json?country_name=Philippines&page=1
  def feed
    @feeds = Feed.joins(:poi).where('pois.approved', true)
                             .where(:country_name => params['country_name'])
                             .latest.paginate(:per_page => 10, :page => params[:page])

    respond_to do |format|
      format.json
    end
  end

  private
    def get_poi_list_by_country_and_or_poi_type_name
      country = Country.find_by_country_name(params[:country_name] || "Philippines")

      #_pois = country.pois.with_gps.most_viewed.latest.paginate(:per_page => 10, :page => params[:page])
      unless params[:poi_type_name].blank?
        poi_type_name = params[:poi_type_name].singularize
        #_pois = country.pois.with_gps.where(:poi_type_name => poi_type_name).latest_viewed.paginate(:per_page => 10, :page => params[:page])
        _pois = country.pois.with_gps.only_approved.where(:poi_type_name => poi_type_name)
      else
        #_pois = country.pois.with_gps.latest_viewed.paginate(:per_page => 10, :page => params[:page])
        _pois = country.pois.with_gps.only_approved
      end

      _pois
    end

    def paginate_and_render_results(_pois)
      @pois = _pois.paginate(:per_page => 10, :page => params[:page])
      render_results(@pois)
    end

    def render_results(_pois)
      respond_to do |format|
        format.html {
          if _pois.size > 0
            render :template => "pois/results"
          else
            render :template => "pois/no_results"
          end
        }
        format.json { render :template => "pois/results" }
      end
    end

    def degrees_to_radians(degree)
      degree * Math::PI / 180
    end

    def find_nearby(country_id, latitude, longitude)
      _pois = Poi.search(
        :with => { :country_id => country_id },
        :without => { :geocoded => 0, :approved => 0 },
        :page => (params[:page] || 1),
        :per_page => 10,
        :geo => [degrees_to_radians(latitude.to_f), degrees_to_radians(longitude.to_f)] ,
        :order => "@geodist ASC"
      )

      return _pois
    end

    def find_rooms(partner_hotels)
      data = []
      unless partner_hotels.count == 1 and partner_hotels.first.partner_type == "HotelsCombined"
        partner_hotels.each do |partner_hotel|
          partner_hotel.rooms.each do |room|
            r = {}
            r[:partner] = partner_hotel.partner_label
            r[:room_type] = room.room_type
            r[:currency_code] = room.currency_code
            r[:rate] = number_with_precision(room.rate, :precision => 2)
            r[:date_from] = room.date_from.to_s(:small)

            if @user_agent
              if @user_agent == 'ipad'
                r[:url] = partner_hotel.web_partner_url
              else
                r[:url] = partner_hotel.mobile_partner_url
              end
            else
              r[:url] = partner_hotel.mobile_partner_url
            end

            data.push(r)
          end
        end
      end
      return data
    end

end
