class Admin::AnswersController < Admin::AdminBaseController
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_feedback, only: [:new, :create, :edit, :update, :destroy]
  respond_to :html

  def new
    @answer = @feedback.answers.new
    @answer.user_id = @feedback.user_id
    respond_with(@answer)
  end

  def edit
  end

  def create
    @answer = @feedback.answers.new(answer_params)
    @answer.save
    respond_with(['admin', @feedback])
  end

  def update
    @answer.update(answer_params)
    respond_with(['admin', @feedback])
  end

  def destroy
    @answer.destroy
    respond_with(['admin', @feedback])
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_feedback
    @feedback = Feedback.find(params[:feedback_id])
  end

  def answer_params
    params.require(:answer).permit(:user_id, :feedback_id, :content)
  end
end
