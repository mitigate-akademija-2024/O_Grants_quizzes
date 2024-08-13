class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show edit update destroy start submit ]

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
    # Retrieve user answers from params, default to empty hash if nil
    user_answers = params[:answers] || {}
  
    # Handle case where no answers are selected
    if user_answers.empty?
      flash.now[:alert] = "You haven't selected any answers. Please make sure to answer all questions."
      @questions = @quiz.questions.includes(:answers)
      render :start and return
    end
  
    unanswered_questions = []
  
    # Check if there are unanswered questions
    @quiz.questions.each do |question|
      if user_answers[question.id.to_s].blank?
        unanswered_questions << question
      end
    end
  
    if unanswered_questions.any?
      flash.now[:alert] = "You have unanswered questions."
      @questions = @quiz.questions.includes(:answers)
      render :start
    else
      # Calculate the score
      @score = 0
      @quiz.questions.each do |question|
        correct_answer = question.answers.find_by(correct: true)
        if user_answers[question.id.to_s] == correct_answer.id.to_s
          @score += 1
        end
      end
      redirect_to results_quiz_path(@quiz, score: @score)
    end
  end
  
  
  
  

  def results
    @score = params[:score]  # This should be set from the redirect
    @quiz = Quiz.find(params[:id])  # Ensure quiz is fetched correctly
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
    @quiz = Quiz.new(quiz_params)

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
end

