class FriendshipsController < ApplicationController
	def index
		@friends = current_user.friends
	end

	def new
		@new_friends = User.not_friend(current_user)
	end

	def create
		friend = current_user.friendships.new(friend_id: params[:friend_id])
		inverse_friend = Friendship.new(user_id: params[:friend_id], friend_id: current_user.id)
		if friend.save && inverse_friend.save
			flash[:success] = "Add new friend success"
			redirect_to new_friendship_path
		else
			flash[:error] = "Something wrong!"
			redirect_to new_friendship_path
		end
	end

	def destroy
		friendship = Friendship.find_by(user_id: current_user.id)
		inverse_friendship = Friendship.find_by(user_id: params[:id])
		friendship.destroy if friendship
		inverse_friendship.destroy if inverse_friendship
		flash[:success] = "Removed friendship"
		redirect_to friendships_path
	end
end
