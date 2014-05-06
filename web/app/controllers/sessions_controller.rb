class SessionsController < ApplicationController
  def new
  end

  def create
    result = PL::SignIn.run({ twitter: params[:twitter], password: params[:password] })
    if result.success?
      session[:pl_session_id] = result.session_id
      return redirect_to select_artist_path
    else
      flash[:notice] = "you messed up somewhere, mf"
      return redirect_to sign_in_path
    end
  end

  def destroy
    PL::SignOut.run({ session_id: session[:pl_session_id] })
    reset_session
    return redirect_to root_path
  end

end
