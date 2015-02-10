# User sends messages.
class FeedbacksController < ApplicationController
  def create
    @feedback = current_user.feedbacks.new(feedback_params)
    respond_to do |format|
      if @feedback.save
        format.js
      else
        format.js { render 'failure' }
      end
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content, :user_id)
  end
end
