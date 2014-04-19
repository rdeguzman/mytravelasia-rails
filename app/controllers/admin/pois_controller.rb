class Admin::PoisController < Admin::ApplicationController
  before_filter :authorize_by_role, :only => [:new, :create]
  before_filter :find_and_authorize_user_by_poi, :only => [:edit, :update, :destroy]

  def new
    @poi = Poi.new

    #Somewhere in the South China Sea
    @poi.latitude = 12.349655187620149
    @poi.longitude = 116.06714899999997
  end
  
  def create
    @poi = Poi.new(params[:poi])

    if current_user.partner?
      @poi.approved = false
    elsif current_user.admin?
      @poi.approved = true
    end
    
    if @poi.save
      flash[:notice] = "Poi Created"

      if current_user.partner?
        privilege = PoiUserPrivilege.new
        privilege.poi_id = @poi.id
        privilege.user_id = current_user.id
        privilege.allowed = true
        privilege.save!

        SharedMailer.ownership_request_confirmation_email(current_user.id, @poi.id).deliver
      end

      redirect_to poi_path(@poi)
    else
      render :action => "new"
    end
  end

  def destroy
    privileges = PoiUserPrivilege.where(:poi_id => @poi.id)
    privileges.destroy_all
    @poi.destroy
    flash[:notice] = "Poi was successfully deleted"
    redirect_to destination_path(@poi.destination_id)
  end
  
  def edit
  end
  
  def update
    if @poi.update_attributes(params[:poi])
      flash[:notice] = "Poi Updated."
      redirect_to poi_path(@poi)
    else
      render :action => 'edit'
    end
  end

  def ownerships
    @privileges = PoiUserPrivilege.includes(:poi, :user).latest.paginate(:per_page => 10, :page => params[:page])
  end

  private
    def authorize_by_role
      unless current_user.belongs_to_role? ["admin", "partner"]
        raise CanCan::AccessDenied
      end
    end

    def find_and_authorize_user_by_poi

      @poi = Poi.find(params[:id])

      if current_user.belongs_to_role? ["admin", "partner"]

        if current_user.partner?

          privileges = PoiUserPrivilege.where(:user_id => current_user.id, :poi_id => @poi.id)
          if privileges.empty?
            raise CanCan::AccessDenied
          end

        end

      else
        raise CanCan::AccessDenied
      end

    end
end
