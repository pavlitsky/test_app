Rails.application.routes.draw do
  resources :orders,
            only: %i[index show create] do
    member do
      post :complete
      post :cancel
    end
  end

  resources :users, only: [] do
    member do
      get :account
    end
  end
end
