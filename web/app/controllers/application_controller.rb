class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?, :current_station

  def current_user
    @current_user ||= PL.db.get_user(PL.db.get_uid_from_sid(session[:pl_session_id]))
  end

  def current_station
    @@current_station ||= PL.db.get_station_by_uid(current_user.id)
  end

  def signed_in?
    session[:pl_session_id] != nil
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
