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

    result = PL::SignIn.run({ })
    if result.success?
      session[:pl_session_id] = result.session_id
      raise env["omniauth.auth"].to_yaml
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
