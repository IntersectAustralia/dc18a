class UsersController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    if sort_column == 'role_id'
      @users = User.deactivated_or_approved.joins(:role).reorder("roles.name" + " " + sort_direction).paginate(page: params[:page])
    else
      @users = User.deactivated_or_approved.reorder(sort_column + " " + sort_direction).paginate(page: params[:page])
    end
  end

  def show
  end

  def admin

  end

  def reports

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

  def reject_reason
  end

  def reject
    reason = params[:user][:rejected_reason]
    if reason.blank?
      redirect_to(reject_reason_user_path(@user), :alert => "You must specify a rejected reason.")
    else
      @user.reject_access_request(reason)
      @user.destroy
      redirect_to(access_requests_users_path, :notice => "The access request for #{@user.user_id} was rejected.")
    end
  end

  def reject_as_spam
    @user.reject_access_request("Spam")
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.user_id} was rejected and this staff/student id will be permanently blocked.")
  end

  def edit_role
    if @user == current_user
      flash.now[:alert] = "You are changing the role of the user you are logged in as."
    elsif @user.rejected?
      redirect_to(users_path, :alert => "Role can not be set. This user has previously been rejected as a spammer.")
    end

    if @user.researcher?
      @roles = Role.by_name
    else
      @roles = Role.where("name != 'Researcher'")
    end

  end

  def edit_approval
    @roles = Role.by_name
  end

  def update_role
    if params[:user][:role_id].blank?
        redirect_to(edit_role_user_path(@user), :alert => "Please select a role for the user.")
    else
      @user.role_id = params[:user][:role_id]
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

  def edit_detail
    @user = User.find(params[:id])
  end

  def update_detail
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to(users_path, :notice => "User details has been updated")
    else
      flash[:alert] = "User details was not updated"
      render 'edit_detail'
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
