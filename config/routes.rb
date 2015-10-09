Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :sessions, only: [:create] do
        resources do
          delete :destroy
        end
      end
    end
  end

  root to: 'pages#index'

  resources :pages, only:[] do
    get :check_session
  end

  resources :sessions, only: [] do
    collection do
      delete :destroy
      get :check
      end
  end
  resources :pages, only: [:index]
end
