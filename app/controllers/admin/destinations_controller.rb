class Admin::DestinationsController < Admin::ApplicationController
  def new
    @destination = Destination.new
  end
  
  def create
    @destination = Destination.new(params[:destination])
    
    if @destination.valid?
      country = @destination.country
      
      @destination.save
      
      flash[:notice] = 'Destination was successfully created'
      redirect_to admin_country_path(country)
    else
      render :action => "new"
    end
  end
  
  def show
    @destination = Destination.find(params[:id])
    @country = @destination.country
    @descriptions = @destination.descriptions
    
    if params[:order]
      @pois = Poi.where(:destination_id => @destination.id).order(params[:order]).paginate(:page => params[:page], :per_page => 10)
    else
      @pois = Poi.where(:destination_id => @destination.id).paginate(:page => params[:page], :per_page => 10)
    end
  end
  
  def destroy
    destination = Destination.find(params[:id])
    if destination.pois.count == 0
      destination.destroy
      flash[:notice] = "Destination was successfully deleted"
      redirect_to admin_country_path(destination.country_id)
    else
      flash[:alert] = "You cannot delete a destination if it has one or more pois. Delete the pois first before deleting the destination."
      redirect_to admin_destination_path(destination)
    end
  end
  
  def edit
    @destination = Destination.find(params[:id])
    
    country = @destination.country
  end
  
  def update
    @destination = Destination.find(params[:id])
    if @destination.update_attributes(params[:destination])
      flash[:notice] = "Destination was successfully updated."
      redirect_to admin_destination_path(@destination)
    else
      render :action => 'edit'
    end
  end
    
end
