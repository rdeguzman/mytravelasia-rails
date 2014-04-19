class Admin::SupportsController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @supports = Support.latest
  end

  def show
    @support = Support.find(params[:id])
  end

  def destroy
    @support = Support.find(params[:id])
    @support.destroy
    redirect_to(supports_url)
  end

end
