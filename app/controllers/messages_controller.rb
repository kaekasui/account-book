class MessagesController < ApplicationController
  def index
  end

  def show
    @message = Message.find(params[:id])
    @target_feedback = @message.feedback
  end
end
