class Admin::DashboardController < Admin::ApplicationController

  def index
    if current_user.role == "normal"
      redirect_to root_path, {:notice => "Hi, this is not an error message but we have redirected you to our home page. The previous request is restricted to admins and moderators only."}
    else
      @pois_total = Poi.count

      @poi_total_stats = Poi.find_by_sql('SELECT country_name, count(*) as total from pois GROUP BY country_name')

      @poi_type_stats = Poi.find_by_sql('SELECT country_name, poi_type_name, count(*) as total from pois GROUP BY country_name, poi_type_name')

      @picture_statistics = Poi.find_by_sql('SELECT country_name, count(*) as total_pictures from pois WHERE total_pictures > 0 GROUP BY country_name')

      render 'index'
    end
  end

end