class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?
  protect_from_forgery with: :null_session
  # skip_before_action :verify_authenticity_token, only: [:create]


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])

  end  

  def after_sign_out_path_for(resource_or_scope)
      new_user_session_path   
  end
end

