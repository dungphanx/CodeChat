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

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			if auth.info.email
				user.email = auth.info.email
			else
				user.email = "#{auth.uid}@facebook.com"
			end
			user.avatar = auth.info.image
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.password = "123"
			user.save!
		end
	end
end
