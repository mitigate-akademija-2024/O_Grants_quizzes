class QuestionsController < ApplicationController
  before_action :set_quiz, only: [:new, :create, :add_answer]
  before_action :set_question, only: [:destroy, :edit, :update]
  before_action :authorize_user!, only: [:edit, :update, :destroy, :new, :create]  # Ensure only quiz owner can edit, update, or delete

  def index
  end

  def create
    @question = @quiz.questions.new(question_params)

    if params[:commit] == "add_answer"
      @question.answers.new
      render :new, status: :unprocessable_entity
    else
      if @question.save
        flash.notice = "Question was successfully created."
        redirect_to quiz_url(@quiz)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def new
    @question = @quiz.questions.new
    @question.answers.new
  end

  def edit
    @quiz = @question.quiz
  end

  def update
    if @question.update(question_params)
      redirect_to quiz_url(@question.quiz), notice: "Question was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def add_answer
    @question = @quiz.questions.new(question_params)
    @question.answers.new

    render :new
  end

  def destroy
    @question.destroy!
    redirect_to quiz_path(@question.quiz), notice: "Question was successfully destroyed."
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_text, answers_attributes: [:id, :answer_text, :correct, :_destroy])
  end

  def authorize_user!
    # This method will check if a user is signed in and if they are the owner of the quiz.
    if current_user.nil? || @quiz.user != current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to quizzes_path
    end
  end
end
