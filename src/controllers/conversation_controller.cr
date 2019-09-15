class ConversationController < ApplicationController
  def create
  end

  def show
    conversation = Conversation.find(params[:id]) || Conversation.new
    other_id = conversation.non_current_user_id(current_user)
    render("show.ecr")
  end

  def destroy
  end
end