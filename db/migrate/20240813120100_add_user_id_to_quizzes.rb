class AddUserIdToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_reference :quizzes, :user, null: false, foreign_key: true
  end
end
