class SessionsController < ApplicationController
  def new
  end

  def create
  	if @user = User.find_by(email: params[:email])
  		if @user.authenticate(params[:password])
  			flash[:success] = "Welcome back #{@user.name}!"
  			session[:user_id] = @user.id
  			redirect_to messages_path
  		else
  			flash[:error] = "Password not right!"
  			redirect_to root_path
  		end
  	else
  		flash[:error] = "Please enter your email and password"
  		redirect_to root_path
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_path, notice: "Logged out"
  end
end
