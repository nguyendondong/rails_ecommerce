class Admin::ApplicationController < ApplicationController
  before_action :require_role_admin

  private

  def require_role_admin
    return if current_user.admin?

    flash[:error] = "You don't have right to access this page"
    redirect_to root_path
  end 
end
