class UsersController < ApplicationController
  before_filter :find_and_authorize_user, :only => [:show, :edit, :update, :edit_password, :update_password, :welcome_partner]

  def show
  end

  def edit
  end

  def update
    if @user.update_without_password(params[:user])
      flash[:notice] = "Updated Profile Successfully"
      redirect_to user_path(@user)
    else
      render :action => 'edit'
    end
  end

  def edit_password
  end

  def update_password
    if @user.update_attributes(params[:user])
      flash[:notice] = "Password was successfully updated. Please login."
      redirect_to root_path
    else
      render :action => 'edit_password'
    end
  end

  def new_partner
    @user = User.new
    @user.role = "partner"
  end

  def create_partner
    @user = User.new(params[:user])
    @user.role = params[:user][:role]

    if @user.save
      flash[:notice] = "Partner Registration Successful"
      SharedMailer.registration_successful_email(@user).deliver
      sign_in @user
      redirect_to welcome_partner_path(:id => @user.id)
    else
      render :action => "new_partner"
    end
  end

  def welcome_partner
  end

  def pois
    @user = User.find(params[:id])
    @privileges = @user.poi_user_privileges.paginate(:page => 1, :per_page => 10)
  end

  def request_ownership
    current_privileges = PoiUserPrivilege.where(:poi_id => params[:id], :user_id => current_user.id)

    if current_privileges.empty?
      privilege = PoiUserPrivilege.new
      privilege.user_id = current_user.id
      privilege.poi_id = params[:id]
      privilege.allowed = false
      privilege.save

      SharedMailer.ownership_request_confirmation_email(current_user.id, params[:id]).deliver

      flash[:notice] = "Request for Ownership successfully submitted."
      redirect_to partner_pois_path(:id => current_user.id)
    else
      flash[:error] = "You have a previous request for ownership already. Please check on 'My Listing'"
      redirect_to poi_path(:id => params[:id])
    end

  end

  private
    def find_and_authorize_user
      if user_signed_in?
        if current_user.admin?
          @user = User.find(params[:id])
        else
          @user = User.find(params[:id])
          if @user != current_user
            raise CanCan::AccessDenied
          end
        end
      else
        raise CanCan::AccessDenied
      end
    end

end