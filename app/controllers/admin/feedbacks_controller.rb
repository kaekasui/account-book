# Administrator manages user's feedbacks.
class Admin::FeedbacksController < Admin::AdminBaseController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @feedbacks = Feedback.all
    respond_with(@feedbacks)
  end

  def show
    respond_with(['admin', @feedback])
  end

  def edit
  end

  def update
    @feedback.update(feedback_params)
    respond_with(['admin', @feedback])
  end

  def destroy
    @feedback.destroy
    respond_with(['admin', @feedback], location: admin_feedbacks_path)
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:content, :user_id)
  end
end
