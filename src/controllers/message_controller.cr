class MessageController < ApplicationController
  def create
    if current_user
      msg = Message.create(
              conversation_id: params[:conversation_id],
              user_id: current_user.try(&.id),
              body: params[:body]
            )
      if msg.new_record?
        flash[:danger] = "Failed to send message."
      else
        flash[:success] = "Message sent."
      end
    else
      flash[:danger] = "Please log in to send message."
    end

    redirect_to "/conversations/#{params[:conversation_id]}"
  end

  def destroy
  end
end