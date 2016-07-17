class Message < ApplicationRecord
	belongs_to :sender, class_name: 'User'
	belongs_to :recipient, class_name: 'User'

	scope :unread, -> { where(read_at: nil) }


	def mark_as_read!
		self.read_at = Time.now
		save!
	end

	def read?
		read_at
	end

	scope :involving, -> (user) do
  	  where("messages.sender_id =? OR messages.recipient_id =?",user.id,user.id)
  	end

    scope :sent, -> (user) do
      where("messages.sender_id = ?", user.id)
	end

	scope :receiver, ->(user) { where("messages.recipient_id = ?", user) }
   
end
