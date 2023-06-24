class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  # 管理者かどうかの確認
  # before_action :check_admin

  # def check_admin
  #   redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user&.admin?
  # end
  def after_sign_in_path_for(resource)
    userhome_users_path
  end

  def after_sign_up_path_for(resource)
    userhome_users_path
  end
end
