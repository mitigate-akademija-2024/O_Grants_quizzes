class QuestionsController < ApplicationController
  before_action :set_quiz, only: [:new, :create]

  def index
  end

  def create
    @question = @quiz.questions.new(question_params)
    if @question.save
      flash.notice = "Question was successfully created."
      redirect_to quiz_url(@quiz)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def start
  end

  def new
    @question = @quiz.questions.new
  end

  def test
  end

  private 

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def question_params
    params.require(:question).permit(:question_text)
  end
end
