class Admin::UsersController < Admin::ApplicationController
  authorize_resource

  before_action :load_user, only: :update

  def index
    @pagy, @users = pagy(load_users, items: Settings.order.admin.paginates)
  end

  def update
    if @user.update(status: params[:status])
      flash[:success] = "User's status was updated successfully!"
    else
      flash.now[:error] = "Failed to update User's status!"
    end
    redirect_to action: :index
  end

  private

  def load_user
    return if @user = User.find_by(id: params[:id])

    flash[:error] = "User doesn't exist!"
    redirect_to action: :index
  end

  def load_users
    return User.user if params[:status].blank?

    User.user.where(status: params[:status])
  end
end
