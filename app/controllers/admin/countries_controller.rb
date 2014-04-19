class Admin::CountriesController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @countries = Country.all
  end
  
  def new
    @country = Country.new
  end
  
  def create
    @country = Country.create(params[:country])
    
    if @country.save
      redirect_to admin_countries_path, :notice => "Country was successfully created"
    else
      render :action => "new"
    end
    
  end
  
  def show
    @country = Country.find(params[:id])
    @destinations = @country.destinations.order(:destination_name)
    @descriptions = @country.descriptions
    order_by = params[:order] || 'updated_at DESC'
    @pois = @country.pois.order(order_by).paginate(:per_page => 10, :page => params[:page])
  end
  
  def destroy
    country = Country.find(params[:id])
    if country.destinations.count == 0
      country.destroy
      flash[:notice] = "Country was successfully deleted"
      redirect_to admin_dashboard_path
    else
      flash[:alert] = "You cannot delete a country if it has one or more destinations. Delete the destinations first before deleting the country."
      redirect_to admin_country_path(country)
    end 
  end
  
  def edit
    @country = Country.find(params[:id])
  end
  
  def update
    @country = Country.find(params[:id])
    if @country.update_attributes(params[:country])
      flash[:notice] = "Country was successfully updated."
      redirect_to admin_country_path(@country)
    else
      render :action => 'edit'
    end
  end
end
