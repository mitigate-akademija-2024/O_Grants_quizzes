Rails.application.routes.draw do
  root 'quizzes#index'

  resources :quizzes do
    resources :questions, shallow: true
    get 'start', on: :member
    post 'submit', on: :member
    get 'results', on: :member
  end

  get "up" => "rails/health#show", as: :rails_health_check
end

