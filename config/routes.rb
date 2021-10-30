Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrationss"
  }

  root :to => "homes#top"
  get "home/about" => "homes#about"
  get "search" => "searches#search"

  resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :following, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end
  
  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]

end
