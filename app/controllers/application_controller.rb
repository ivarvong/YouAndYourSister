require 'securerandom'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_guest_id

  helper_method :current_user
  
  private

	  def current_user
	    @current_user ||= User.find(session[:user_id]) if session[:user_id]
	  end

	  def ensure_guest_id
	  	if cookies.permanent.signed[:guest_id].nil?
	  		logger.debug "created cookie!"
	  		cookies.permanent.signed[:guest_id] = SecureRandom.base64(20)
	  	end	  	
	  end

end
