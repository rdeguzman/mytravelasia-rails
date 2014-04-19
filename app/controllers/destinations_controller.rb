class DestinationsController < ApplicationController
  def show
    @destination = Destination.find(params[:id])
    @country = @destination.country
    @descriptions = @destination.descriptions

    if not params[:order].blank? #then filtered is applied
      search_options = { :page => 1, :per_page => 1000 }
    else
      search_options = { :page => params[:page] || 1, :per_page => 10}
    end

    keywords = "#{@destination.name} #{@country.name}"
    pois = Poi.search(keywords, search_options)

    if params[:order]
      ids = pois.collect{|p| p.id}
      @pois = Poi.where(:id => ids ).order(params[:order]).paginate(:page => params[:page], :per_page => 10)
    else
      @pois = pois
    end

    current_navigation @country.country_name.parameterize.underscore.to_sym
  end

  def index
    @country = Country.find(params[:country_id])
    @all_destinations = @country.destinations.top_destinations_with_pois.alphabetically
  end

end
