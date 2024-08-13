Rails.application.routes.draw do
  # Set the root path
  root 'quizzes#index'

  # Resources for quizzes with member routes
  resources :quizzes do
    resources :questions, shallow: true

    # Member routes
    get 'start', on: :member
    post 'submit', on: :member
    get 'results', on: :member

    # Collection route for showing all completed quizzes
    get 'completed', on: :collection
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end

