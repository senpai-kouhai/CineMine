class ApplicationController < ActionController::Base
  # 管理者かどうかの確認
  # before_action :check_admin

  # def check_admin
  #   redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user&.admin?
  # end
end
