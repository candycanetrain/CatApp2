class SessionsController < ApplicationController

  before_action :signed_in, except: [:destroy]

  def signed_in
    redirect_to cats_url if current_user
  end

  def create
   @user = User.find_by_credentials(params[:session][:user_name], params[:session][:password])
   if @user
     login_user!(@user)
   else
     flash[:errors] = ["Invalid credentials"]
     redirect_to new_session_url
   end
  end

  def new
    render :new
  end

  def destroy
    logout
    redirect_to new_session_url
  end

  private
  def session_params
    params.require(:session).permit(:user_name, :password)
  end

end
