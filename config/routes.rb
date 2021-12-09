# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :recommendations, only: %i[index create update show]
    end
  end
end
