require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web, at: '/sidekiq'

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
      resources :feedback, only: [:create]
      resources :search, only: [:index]
      resources :location, only: [] do
        collection do
          put :update
          delete :destroy
        end
      end
      resources :messages, only: [:create] do
        collection do
          get :unread
        end
      end
      resources :conversations, only: [:index, :show, :destroy]
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
