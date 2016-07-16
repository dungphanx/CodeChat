class User < ApplicationRecord
	validates :name, presence: true
	validates :email, presence: true, uniqueness: {case_insensitive: false}
	has_secure_password

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
end
