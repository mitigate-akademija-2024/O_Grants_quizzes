class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show edit update destroy ]

  # GET /quizzes or /quizzes.json
  def index
    @quizzes = Quiz.all

    @title = "These are all the quizzes"
    @description = "Here are stored all the quizzes"
  end

  def start
    @title = "Start Quiz"
    @description = "Get ready to start your quiz. Good luck"

    respond_to do |format|
      format.html
      format.json do
        render json: { title: @title, description: "Šī ir json atbilde" }
      end
    end
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
    @quiz = Quiz.find(params[:id])
    @questions = @quiz.questions.includes(:answers)
  end

  def submit
    @quiz = Quiz.find(params[:id])
    answers_params = params[:answers] || {}
    score = 0

    @quiz.questions.each do |question|
      selected_answer_ids = answers_params[question.id.to_s] || []
      correct_answers = question.answers.where(correct: true).pluck(:id)

      score += 1 if (selected_answer_ids.map(&:to_i) & correct_answers).sort == correct_answers.sort
    end

    flash[:notice] = "Your score is #{score} out of #{@quiz.questions.count}."
    redirect_to quiz_path(@quiz)
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  @question = Question.find(params[:id])
  @quiz = @question.quiz
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
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:title, :description)
    end
end
