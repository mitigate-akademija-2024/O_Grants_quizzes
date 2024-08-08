class Answer < ApplicationRecord
    validates :answer_text, presence: true

    belongs_to :question
end
