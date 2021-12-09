Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :recommendations, only: [:index, :create, :update, :show]
    end
  end
end
