class ConversationController < ApplicationController
  @conversation = Conversation.new

  def create
    if current_user && (!existing_convo.new_record? || !create_convo.new_record?)
      redirect_to "/conversations/#{@conversation.id}"
    else
      redirect_to "/users/#{params[:other_id]}"
    end
  end

  def show
    conversation = Conversation.find(params[:id]) || Conversation.new
    other_id = conversation.non_current_user_id(current_user)
    render("show.ecr")
  end

  def destroy
  end

  private def existing_convo
    @conversation = Conversation.find_by(starter_id: current_user.try(&.id), recipient_id: params[:other_id]) ||
                    Conversation.find_by(starter_id: params[:other_id], recipient_id: current_user.try(&.id)) ||
                    Conversation.new
  end

  private def create_convo
    @conversation = Conversation.create(starter_id: current_user.try(&.id), recipient_id: params[:other_id])
    recipient = User.find(params[:other_id])
    return Conversation.new if @conversation.new_record? || !recipient
    @conversation.user << recipient
    @conversation.user << (current_user || User.new)
    @conversation
  end
end