class Admin::DashboardController < Admin::ApplicationController

  def index
    if current_user.role == "normal"
      redirect_to root_path, {:notice => "Hi, this is not an error message but we have redirected you to our home page. The previous request is restricted to admins and moderators only."}
    else
      @pois_total = Poi.count
      @pois_no_pictures = Poi.where(:total_pictures => 0).count
      @pois_no_pictures_grouped = Poi.where(:total_pictures => 0).count(:group => :poi_type_name)
      @pois_no_location = Poi.where("latitude is null OR latitude = 0 OR longitude is null OR longitude = 0").count
      @pois_no_location_grouped = Poi.where("latitude is null OR latitude = 0 OR longitude is null OR longitude = 0").count(:group => :poi_type_name)
      @pois_no_description = Poi.where("description is null OR description = ''").count
      @countries = Country.alphabetically

      @poi_statistics = Poi.find_by_sql('SELECT country_name, poi_type_name, count(*) as total from pois GROUP BY country_name, poi_type_name')

      render 'index'
    end
  end

end