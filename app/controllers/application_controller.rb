class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  # Changement des paramètres du formulaire d'inscription
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :last_name, :first_name])
  end

  def after_sign_in_path_for(resource)
    dashboard_index_path
end

end
