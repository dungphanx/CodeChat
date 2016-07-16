class SessionsController < ApplicationController
  def new
  end

  def create
  	if @user = User.find_by(email: params[:email])
  		if @user.authenticate(params[:password])
  			flash[:success] = "Welcome back #{@user.name}!"
  			session[:user_id] = @user.id
  			redirect_to root_path
  		else
  			flash[:error] = "#{@user.errors.full_messages.to_sentence}"
  			redirect_to new_session_path
  		end
  	else
  		flash[:error] = "#{@user.errors.full_messages.to_sentence}"
  		redirect_to new_session_path
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_path, notice: "Logged out"
  end
end
