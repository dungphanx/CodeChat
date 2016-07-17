class MessagesController < ApplicationController
	def index
		@messages = Message.receiver(current_user).order(created_at: :desc)
	end

	def show
		@message = Message.find params[:id]
		if !@message.read? && current_user == @message.recipient
			@message.mark_as_read!
		end
	end

	def new
		@users = User.all_except(current_user)
		@message = Message.new
	end

	def create
		@message = Message.new(message_params)
		@message.sender_id = current_user.id
		
		if @message.save!
			redirect_to messages_path
		else
			render 'new'
		end
	end

	def sent
		@messages = Message.sent(current_user).order(created_at: :desc)
		
		selected_message_index = params[:message_id]
		if @messages.count > 0
			if !selected_message_index.nil?
				@select_message = @messages.find(selected_message_index)
			else
				@select_message = @messages.first
			end
		end
	end

	private
	def message_params
		params.require(:message).permit(:sender ,:body, :recipient_id)
	end
end
