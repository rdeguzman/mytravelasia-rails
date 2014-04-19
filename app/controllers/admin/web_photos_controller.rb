class Admin::WebPhotosController < Admin::ApplicationController
  def new
    @web_photo = WebPhoto.new
  end
  
  def edit
    @web_photo = WebPhoto.find(params[:id])
  end
  
  def update
    @web_photo = WebPhoto.find(params[:id])
    @web_photo.user_id = current_user.id
    
    if @web_photo.update_attributes(params[:web_photo])
      flash[:notice] = "Caption was successfully updated."
      redirect_to poi_path(@web_photo.poi_id)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    web_photo = WebPhoto.find(params[:id])
    id = web_photo.parent_id
    web_photo.destroy
    flash[:notice] = "WebPhoto was successfully deleted"
    redirect_to poi_path(@web_photo.poi_id)
  end
    
end
