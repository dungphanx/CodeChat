class User < ApplicationRecord
	validates :name, presence: true
	validates :email, presence: true, uniqueness: {case_insensitive: false}
	
	has_secure_password
	
	has_many :friends, through: :friendships
	has_many :friendships

	mount_uploader :avatar, AvatarUploader

	def avatar_img
		if avatar.present?
			avatar
		else
			'http://www.valtine.com/wp-content/themes/intima/images/avatar.jpg'
		end
	end

	def self.all_except(user)
  		where.not(id: user)
	end

	def received_messages
		where(recipient: self)
	end

	def sent_messages
		where(sender: self)
	end

	def lastest_received_messages(n)
		received_messages.order(created_at: :desc).limit(n)
	end

	def unread_messages
		received_messages.unread
	end

	def self.not_friend current_user
		friendIds =  current_user.friends.pluck(:friend_id)
		friendIds.push(current_user.id)
		User.where.not(id: friendIds) 
	end
end
