# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      devise_for :users,
                 controllers: {
                   sessions: 'user/sessions',
                   registrations: 'user/registrations'
                 }

      resources :users do
        member do
          resources :recommendations, only: %i[index create update show]
        end
      end
      get '/me', to: 'members#show'
    end
  end
end
