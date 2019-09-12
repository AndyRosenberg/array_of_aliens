class ConversationController < ApplicationController
  def create
  end

  def show
    conversation = Conversation.find(params[:id]) || Conversation.new
    render("show.ecr")
  end

  def destroy
  end
end