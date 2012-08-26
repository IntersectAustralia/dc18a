class UsersController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.deactivated_or_approved.reorder(sort_column + " " + sort_direction).paginate(page: params[:page])
  end

  def show
  end

  def admin

  end

  def access_requests
    @users = User.pending_approval
  end

  def deactivate
    if !@user.check_number_of_superusers(params[:id], current_user.id) 
      redirect_to(@user, :alert => "You cannot deactivate this account as it is the only account with Administrator privileges.")
    else
      @user.deactivate
      redirect_to(@user, :notice => "The user has been deactivated.")
    end
  end

  def activate
    @user.activate
    redirect_to(@user, :notice => "The user has been activated.")
  end

  def reject
    @user.reject_access_request
    @user.destroy
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.user_id} was rejected.")
  end

  def reject_as_spam
    @user.reject_access_request
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.user_id} was rejected and this staff/student id will be permanently blocked.")
  end

  def edit_role
    if @user == current_user
      flash.now[:alert] = "You are changing the role of the user you are logged in as."
    elsif @user.rejected?
      redirect_to(users_path, :alert => "Role can not be set. This user has previously been rejected as a spammer.")
    end
    @roles = Role.by_name
  end

  def edit_approval
    @roles = Role.by_name
  end

  def update_role
    if params[:user][:role].blank?
        redirect_to(edit_role_user_path(@user), :alert => "Please select a role for the user.")
    else
      @user.role_id = params[:user][:role]
      if !@user.check_number_of_superusers(params[:id], current_user.id)
        redirect_to(edit_role_user_path(@user), :alert => "Only one superuser exists. You cannot change this role.")
      elsif @user.save
        redirect_to(@user, :notice => "The role for #{@user.user_id} was successfully updated.")
      end
    end
  end

  def approve
    if !params[:user][:role].blank?
      @user.role_id = params[:user][:role]
      @user.save
      @user.approve_access_request

      redirect_to(access_requests_users_path, :notice => "The access request for #{@user.user_id} was approved.")
    else
      redirect_to(edit_approval_user_path(@user), :alert => "Please select a role for the user.")
    end
  end
end

private

def sort_column
  User.column_names.include?(params[:sort]) ? params[:sort] : "user_id"
end

def sort_direction
  %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
end
