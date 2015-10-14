Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        collection do
          put :update_profile
        end
      end
      resources :sessions, only: [:create] do
        collection do
          delete :destroy
          delete :destroy_all
          post :facebook
        end
      end
      resources :passwords, only: [:create]
    end
  end

  root to: 'pages#index'

  resources :passwords, only: [] do
    collection do
      put :update
      get :edit
    end
  end

  resources :pages, only: [:index]
end
