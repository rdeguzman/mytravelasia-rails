class Admin::PicturesController < Admin::ApplicationController
  def index
    @poi = Poi.find(params[:poi_id])
    @pictures = @poi.pictures
    @web_photos = @poi.web_photos
  end
  
  def create
    #You can specify a sleep here to mimic a long response
    #sleep 5
    newparams = coerce(params)
    
    #current_pictures = Picture.find(:all, :conditions => { :poi_id => params[:poi_id]})
    current_pictures = Picture.where(:poi_id => params[:poi_id]).all
    
    @picture = Picture.new(newparams[:picture])
    @picture.user_id = current_user.id
    
    if @picture.save
      flash[:notice] = "Picture successfully uploaded."
      
      respond_to do |format|
        format.html {redirect_to admin_pictures_path(:poi_id => @picture.poi_id)}
        
        if current_pictures.empty?
          format.json {render :json => {:result => 'success',
                                        :picture => url_for(:controller => 'admin/pictures', :action => 'show', :id => @picture.id, :first => 'true')}}
        else
          format.json {render :json => { :result => 'success', :picture => admin_picture_path(@picture) } }
        end
      end
    else
      flash[:alert] = "There is an error in saving the picture."
      respond_to do |format|
        format.html {redirect_to admin_pictures_path(:poi_id => @picture.poi_id)}
        format.json {render :json => { :result => 'error', :error => flash[:alert] } }
      end
    end
  end

  def show
    @picture = Picture.find(params[:id], :include => :poi)
    @total_pictures = Picture.where(:poi_id => @picture.poi_id).count
    render :template => 'admin/pictures/show'
  end
  
  def edit
    @picture = Picture.find(params[:id])
  end
  
  def update
    @picture = Picture.find(params[:id])
    @picture.user_id = current_user.id
    
    if @picture.update_attributes(params[:picture])
      flash[:notice] = "Caption was successfully updated."
      redirect_to admin_pictures_path(:poi_id => @picture.poi.id)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    picture = Picture.find(params[:id])
    poi_id = picture.poi_id
    picture.destroy
    flash[:notice] = "Picture Deleted."
    redirect_to admin_pictures_path(:poi_id => poi_id)
  end

  def update_default
    picture = Picture.find(params[:id])

    Poi.skip_callbacks = true
    poi = Poi.find(picture.poi_id)
    poi.picture_thumb_path = picture.image.url(:thumb)
    poi.picture_full_path = picture.image.url(:square)
    poi.save(:validate => false)
    Poi.skip_callbacks = false

    redirect_to admin_pictures_path(:poi_id => picture.poi_id)
  end
    
  private 
    def coerce(params)
      if params[:picture].nil? 
        h = Hash.new 
        h[:picture] = Hash.new 
        h[:picture][:poi_id] = params[:poi_id] 
        h[:picture][:image] = params[:Filedata]
        h[:picture][:image].content_type = MIME::Types.type_for(h[:picture] [:image].original_filename).to_s 
        h
      else 
        params
      end 
    end

end
