class Admin::DescriptionsController < Admin::ApplicationController
  load_and_authorize_resource
  
  def new
    @description = Description.new
    @description.parent_id = params[:parent_id]
    @description.table_name = params[:table_name]
    
    @parent = params[:table_name].camelize.constantize.find_by_id(params[:parent_id])
    @table_name = params[:table_name]
    controller_name = params[:table_name].pluralize
  end
  
  def create
    @description = Description.create(params[:description])
    
    if @description.save
      controller_name = @description.table_name.pluralize
      redirect_to url_for(:controller => "admin/#{controller_name}", :action => 'show', :id => @description.parent_id), :notice => "Description was successfully created"
    else
      @parent = @description.table_name.camelize.constantize.find_by_id(@description.parent_id)
      @table_name = @description.table_name
      render :action => "new"
    end
    
  end
  
  def edit
    @description = Description.find(params[:id])
    @table_name = @description.table_name
    
    @parent = @description.table_name.camelize.constantize.find_by_id(@description.parent_id)
    
    
    controller_name = @description.table_name.pluralize
  end
  
  def update
    @description = Description.find(params[:id])
    if @description.update_attributes(params[:description])
      flash[:notice] = "Description was successfully updated."
      controller_name = @description.table_name.pluralize
      redirect_to url_for(:controller => "admin/#{controller_name}", :action => 'show', :id => @description.parent_id)
    else
      @parent = @description.table_name.camelize.constantize.find_by_id(@description.parent_id)
      @table_name = @description.table_name
      render :action => "edit"
    end
  end
  
  def destroy
    description = Description.find(params[:id])
    description.destroy
    flash[:notice] = "Description was successfully deleted"
    controller_name = description.table_name.pluralize
    redirect_to url_for(:controller => "admin/#{controller_name}", :action => 'show', :id => description.parent_id)
  end
  
end
