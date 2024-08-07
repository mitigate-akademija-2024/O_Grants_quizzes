class Quiz < ApplicationRecord
    validates :title, :description, presence: true
end
