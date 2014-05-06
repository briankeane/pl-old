class UsersController < ApplicationController
  def new
  end

  def create
    if params[:password] != params[:password_confirmation]
      flash[:notice] = "Passwords don't match, mf"
      return redirect_to sign_up_path
    end
    result = PL::CreateUser.run({ twitter: params[:twitter], password: params[:password] })
    if result.success?
      result = PL::SignIn.run({ twitter: params[:twitter], password: params[:password] })
      session[:pl_session_id] = result.session_id
    elsif result.error == :twitter_taken
      flash[:notice] = "that twitter is taken, mf."
      return redirect_to sign_up_path
    end
  end


  def update
  end

  def destroy
  end

  def index
  end

  def show
  end
end
