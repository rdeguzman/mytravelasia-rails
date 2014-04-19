class HomeController < ApplicationController
  def index
    @pois_featured = Poi.featured.latest.with_description.with_pictures.paginate(:per_page => 4, :page => params[:page])
    @pois_most_viewed = Poi.most_viewed.latest.with_description.with_pictures.paginate(:per_page => 4, :page => params[:page])

    @top_destinations = Destination.top_most.alphabetically

    @random_attraction = Poi.with_description.with_pictures.latest_viewed.attraction.first
    @random_hotel = Poi.with_description.with_pictures.latest_viewed.hotel.first
    @random_tour = Poi.with_description.with_pictures.latest_viewed.tour.first
    @random_promo = Poi.with_description.with_pictures.latest_viewed.promo.first
  end

  def list
    poi_type_name = params[:type][0..-2]
    poi_type = PoiType.find_by_poi_type_name(poi_type_name)

    @pois = Poi.where(:poi_type_id => poi_type.id).with_pictures.with_description.latest.paginate(:per_page => 5, :page => params[:page])

    current_navigation :home
  end

  def fullmap
    render :layout => 'fusion-map'
  end

  def beta_testing
  end

  def privacy_policy
  end

end
