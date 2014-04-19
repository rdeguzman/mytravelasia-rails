class CountriesController < ApplicationController
  def show
    @country = Country.find(params[:id])

    @pois_featured = @country.pois.featured.with_description.with_pictures.latest.paginate(:per_page => 4, :page => params[:page])
    @pois_most_viewed = @country.pois.most_viewed.with_description.with_pictures.latest.paginate(:per_page => 4, :page => params[:page])

    @random_attraction = @country.pois.with_description.with_pictures.latest_viewed.attraction.first
    @random_hotel = @country.pois.with_description.with_pictures.latest_viewed.hotel.first
    @random_tour = @country.pois.with_description.with_pictures.latest_viewed.tour.first
    @random_promo = @country.pois.with_description.with_pictures.latest_viewed.promo.first

    @top_destinations = @country.destinations.top_destinations_for_country.alphabetically

    if @country.destinations.count > APP_CONFIG[:country_top_destination_count]
      @all_destinations = @country.destinations.top_limited_destinations_with_pois.alphabetically
    else
      @all_destinations = @country.destinations.top_destinations_with_pois.alphabetically
    end

    @country_descriptions = @country.descriptions

    @exclusive = Poi.where(:country_id => @country.id).exclusive.latest.first
  end

  def list
    poi_type_name = params[:type][0..-2]
    poi_type = PoiType.find_by_poi_type_name(poi_type_name)

    @country = Country.find(params[:id])
    @pois = @country.pois.where(:poi_type_id => poi_type.id).with_description.with_pictures.latest.paginate(:per_page => 5, :page => params[:page])

    current_navigation @country.country_name.parameterize.underscore.to_sym
  end

end
