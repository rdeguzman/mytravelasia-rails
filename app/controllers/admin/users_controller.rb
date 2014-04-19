class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @users = User.latest.paginate(:page => params[:page] || 1, :per_page => 10)
  end

  def allow_ownership
    if user_signed_in? and current_user.admin?
      update_ownership(true)
    else
      raise CanCan::AccessDenied
    end
  end

  def deny_ownership
    if user_signed_in? and current_user.admin?
      update_ownership(false)
    else
      raise CanCan::AccessDenied
    end
  end

  def destroy_ownership
    privilege = PoiUserPrivilege.find(params[:id])
    privilege.destroy
    redirect_to admin_poi_ownerships_path
  end

  private
    def update_ownership(allowed)
      current_privileges = PoiUserPrivilege.where(:user_id => params[:id],
                                                  :poi_id => params[:poi_id])
      if current_privileges.empty?
        flash[:error] = "There is no request for ownership"
      else
        privilege = current_privileges.first
        privilege.allowed = allowed
        privilege.allowed_by = current_user.first_name
        privilege.save

        SharedMailer.ownership_allowed_confirmation_email(params[:id], params[:poi_id], allowed).deliver

        if allowed
          flash[:notice] = "Successfully ALLOWED this user to manage this poi"
        else
          flash[:notice] = "Successfully DENIED this user to manage this poi"
        end

      end

      redirect_to poi_path(:id => params[:poi_id])
    end

end