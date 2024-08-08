class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question, foreign_key: true
      t.string :answer_text, null: false
      t.boolean :correct, null: false, default: false

      t.timestamps
    end
  end
end