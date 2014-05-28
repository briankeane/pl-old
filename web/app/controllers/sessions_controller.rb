require 'pry-debugger'

class SessionsController < ApplicationController
  def new
  end

  def create
    result = PL::SignIn.run({ twitter: params[:twitter], password: params[:password] })
    if result.success?
      session[:pl_session_id] = result.session_id
      return redirect_to dj_booth_path
    else
      flash[:notice] = "you messed up somewhere, mf"
      return redirect_to sign_in_path
    end
  end

  def create_with_twitter
    auth = request.env['omniauth.auth']
    result = PL::SignInWithTwitter.run({ twitter: auth["info"]["nickname"], twitter_uid: auth['uid'] })
    if result.success?
      if result.new_user
        session[:pl_session_id] = result.session_id
        redirect_to station_new_path
      else
        session[:pl_session_id] = result.session_id
        return redirect_to dj_booth_path
      end
    else
      redirect_to sign_in_path
    end


  end


  def destroy
    PL::SignOut.run({ session_id: session[:pl_session_id] })
    reset_session
    return redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end


end
