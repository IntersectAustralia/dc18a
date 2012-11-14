class EditorsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def edit
    @editor = Editor.find_by_id(params[:id])
  end

  def update
    @editor = Editor.find_by_id(params[:id])
    @editor.update_attributes(params[:editor])

    if @editor.save
      flash[:notice] = @editor.name.capitalize + " text updated."
      redirect_to root_path
    else
      flash[:alert] = "Please fill in all mandatory fields."
      render 'edit'
    end
  end

  def cancel
    @editor = Editor.find_by_id(params[:id])
    flash[:alert] = @editor.name.capitalize + " text was not updated."
    redirect_to root_path
  end
end
