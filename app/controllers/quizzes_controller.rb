class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show edit update destroy start submit ]
  before_action :authorize_quiz_creator!, only: %i[ edit update destroy ]  # Ensure only quiz creator can edit, update, or destroy

  # GET /quizzes or /quizzes.json
  def index
    @quizzes = Quiz.all
    @title = "These are all the quizzes"
    @description = "Here are stored all the quizzes"
  end

  def start
    @questions = @quiz.questions.includes(:answers)
  end

  def submit
    user_answers = params[:answers] || {}

    if user_answers.empty?
      flash.now[:alert] = "You haven't selected any answers. Please make sure to answer all questions."
      @questions = @quiz.questions.includes(:answers)
      render :start, status: :unprocessable_entity and return
    end

    unanswered_questions = @quiz.questions.select { |q| user_answers[q.id.to_s].blank? }

    if unanswered_questions.any?
      flash.now[:alert] = "You have unanswered questions."
      @questions = @quiz.questions.includes(:answers)
      render :start, status: :unprocessable_entity
    else
      @user_answers = []
      @score = 0

      @quiz.questions.each do |question|
        user_answer_id = user_answers[question.id.to_s]
        correct_answer = question.answers.find_by(correct: true)

        if user_answer_id == correct_answer&.id.to_s
          @score += 1
        end

        @user_answers << {
          question: question,
          user_answer_id: user_answer_id,
          correct_answer_id: correct_answer&.id
        }
      end

      redirect_to results_quiz_path(@quiz, score: @score, user_answers: @user_answers.to_json)
    end
  end

  def results
    @score = params[:score].to_i
    @quiz = Quiz.find(params[:id])
    @user_answers = JSON.parse(params[:user_answers], symbolize_names: true)
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes or /quizzes.json
  def create
    @quiz = current_user.quizzes.new(quiz_params)

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to quiz_url(@quiz), notice: "Quiz was successfully created." }
        format.json { render :show, status: :created, location: @quiz }
      else
        flash.now.alert = 'Something went wrong'
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1 or /quizzes/1.json
  def update
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to quiz_url(@quiz), notice: "Quiz was successfully updated." }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz.destroy!
    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: "Quiz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to quizzes_path, alert: "Quiz not found."
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:title, :description)
    end

    # Authorization logic to ensure only the quiz creator can modify the quiz.
    def authorize_quiz_creator!
      unless current_user == @quiz.user
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to quizzes_path
      end
    end
end
