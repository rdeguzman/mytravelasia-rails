class Admin::DescriptionTypesController < Admin::ApplicationController
  load_and_authorize_resource
  
  def index
    @description_types = DescriptionType.order(:title)
  end
  
  def new
    @description_type = DescriptionType.new
    #add_#breadcrumb "Description Types", admin_description_types_path
  end
  
  def create
    @description_type = DescriptionType.create(params[:description_type])
    
    if @description_type.save
      redirect_to admin_description_types_path, :notice => "Description Type was successfully created"
    else
      render :action => "new"
    end
    
  end
  
  def edit
    @description_type = DescriptionType.find(params[:id])
    add_#breadcrumb "Description Types", admin_description_types_path
  end
  
  def update
    @description_type = DescriptionType.find(params[:id])
    if @description_type.update_attributes(params[:description_type])
      flash[:notice] = "Description Type was successfully updated."
      redirect_to admin_description_types_path
    else
      render :action => 'edit'
    end
  end
  
  
  def destroy
    description_type = DescriptionType.find(params[:id])
    
    count_descriptions = Description.where(:description_type_id => description_type.id).count
    
    if count_descriptions == 0
      description_type.destroy
      flash[:notice] = "Description Type was successfully deleted"
    else
      flash[:alert] = "You cannot delete a description type if it has one or more descriptions. We found #{count_descriptions}. Delete the descriptions first before deleting the description type."
    end
    
    redirect_to admin_description_types_path 
  end
  
end
