class ApplicationController < ActionController::Base
  include Pagy::Backend

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path, alert: 'You need to sign in or sign up before continuing.'
    end
  end
end
