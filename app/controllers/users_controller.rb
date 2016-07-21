class UsersController < ApplicationController
	before_action :check_authorization, only: [:edit, :update]
	def index
		Rails.logger.info request.env["HTTP_COOKIE"]
		@users = User.all
		@user = User.new
	end

	def new
		@user = User.new
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])

		if @user.update(update_users)
			flash[:success] = "Update successfully!"
			redirect_to @user
		else
			flash[:error] = "Error #{@user.errors.full_messages.to_sentence}" #"Something went wrong, please try again"
			render :edit
		end
	end

	def create
		@user = User.new user_params

		if @user.save
			flash[:success] = "Your account created successful!"
			session[:user_id] = @user.id
			redirect_to root_path, notice: "Account created"
		else
			flash[:error] = "#{@user.errors.full_messages.to_sentence}"
			render 'new'
		end
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password)
	end

	def update_users
		params.require(:user).permit(:name, :avatar)
	end

	def check_authorization
		unless current_user.id == params[:id].to_i
			flash[:error] = "You shouldn't try to edit another profile"
			redirect_to root_path
		end
	end
end
