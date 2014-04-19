class Admin::DestinationTypesController < Admin::ApplicationController
  load_and_authorize_resource
  
  def index
    @destination_types = DestinationType.order(:name)
  end
  
  def new
    @destination_type = DestinationType.new
  end
  
  def create
    @destination_type = DestinationType.create(params[:destination_type])
    
    if @destination_type.save
      redirect_to admin_destination_types_path, :notice => "Destination Type was successfully created"
    else
      render :action => "new"
    end
    
  end
  
  def edit
    @destination_type = DestinationType.find(params[:id])
  end
  
  def update
    @destination_type = DestinationType.find(params[:id])
    if @destination_type.update_attributes(params[:destination_type])
      flash[:notice] = "Destination Type was successfully updated."
      redirect_to admin_destination_types_path
    else
      render :action => 'edit'
    end
  end
  
  
  def destroy
    destination_type = DestinationType.find(params[:id])
    
    count_destinations = Destination.where(:destination_type_id => destination_type.id).count
    
    if count_destinations == 0
      destination_type.destroy
      flash[:notice] = "Destination Type was successfully deleted"
    else
      flash[:alert] = "You cannot delete a destination type if it has one or more destinations. We found #{count_destinations}. Delete the destinations first before deleting the destination type."
    end
    
    redirect_to admin_destination_types_path 
  end
  
end
