class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  def current_user
    TM::Database.db.get_user(TM::Database.db.get_uid_from_sid(session[:tm_session_id]))
  end

  def signed_in?
    session[:tm_session_id] != nil
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
