class Admin::FeedbacksController < Admin::AdminBaseController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @admin_feedbacks = Feedback.all
    respond_with(@admin_feedbacks)
  end

  def show
    respond_with(@admin_feedback)
  end

  def new
    @admin_feedback = Feedback.new
    respond_with(@admin_feedback)
  end

  def edit
  end

  def create
    @admin_feedback = Feedback.new(feedback_params)
    @admin_feedback.save
    respond_with(@admin_feedback)
  end

  def update
    @admin_feedback.update(feedback_params)
    respond_with(@admin_feedback)
  end

  def destroy
    @admin_feedback.destroy
    respond_with(@admin_feedback)
  end

  private
    def set_feedback
      @admin_feedback = Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:name, :user_id)
    end
end
