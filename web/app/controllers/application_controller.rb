class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  def current_user
    PL::Database.db.get_user(PL::Database.db.get_uid_from_sid(session[:pl_session_id]))
  end

  def signed_in?
    session[:pl_session_id] != nil
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
