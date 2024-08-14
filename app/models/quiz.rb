class Quiz < ApplicationRecord
    validates :title, presence: true, uniqueness: true
  
    before_validation :normalize_title
  
    before_save :normalize_description
  
    has_many :questions, dependent: :destroy

    belongs_to :user
  
    protected
  
    def normalize_title
      Rails.logger.info("Quiz#normalize_title called")
      self.title = title.to_s.squish.capitalize
    end
  
    def normalize_description
      Rails.logger.info("Quiz#normalize_description called")
      self.description = description.to_s.squish
    end
  end