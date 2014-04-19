class Admin::PoiTypesController < Admin::ApplicationController
  load_and_authorize_resource
  
  def index
    @poi_types = PoiType.order(:poi_type_name)
  end
  
  def new
    @poi_type = PoiType.new
  end
  
  def create
    @poi_type = PoiType.create(params[:poi_type])
    
    if @poi_type.save
      redirect_to admin_poi_types_path, :notice => "Poi Type was successfully created"
    else
      render :action => "new"
    end
    
  end
  
  def edit
    @poi_type = PoiType.find(params[:id])
  end
  
  def update
    @poi_type = PoiType.find(params[:id])
    if @poi_type.update_attributes(params[:poi_type])
      flash[:notice] = "Poi Type was successfully updated."
      redirect_to admin_poi_types_path
    else
      render :action => 'edit'
    end
  end
  
  
  def destroy
    poi_type = PoiType.find(params[:id])
    
    count_pois = Poi.where(:poi_type_id => poi_type.id).count
    
    if count_pois == 0
      poi_type.destroy
      flash[:notice] = "Poi Type was successfully deleted"
    else
      flash[:alert] = "You cannot delete a poi type if it has one or more pois. We found #{count_pois}. Delete the pois first before deleting the poi type."
    end
    
    redirect_to admin_poi_types_path 
  end
  
end
