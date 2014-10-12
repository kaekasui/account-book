class Admin::FeedbacksController < Admin::AdminBaseController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @admin_feedbacks = Feedback.all
    respond_with(@admin_feedbacks)
  end

  def show
    respond_with(@feedback)
  end

  def new
    @feedback = Feedback.new
    respond_with(@feedback)
  end

  def edit
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @admin_feedback.save
    respond_with(@feedback)
  end

  def update
    @admin_feedback.update(feedback_params)
    respond_with(@feedback)
  end

  def destroy
    @admin_feedback.destroy
    respond_with(@feedback)
  end

  private
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:name, :user_id)
    end
end
