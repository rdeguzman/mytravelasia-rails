class AjaxController < ApplicationController

  def destinations
    @destinations = Destination.where(:country_id => params[:country_id]).alphabetically
    render :partial => "ajax/destinations", :locals => {:destinations => @destinations}
  end
end
