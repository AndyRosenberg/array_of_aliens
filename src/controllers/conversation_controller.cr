class ConversationController < ApplicationController
  def create
  end

  def show
    conversation = Conversation.find(params[:id]) || Conversation.new
    other_user = conversation.not_current_user(current_user)
    render("show.ecr")
  end

  def destroy
  end
end