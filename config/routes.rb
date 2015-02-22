Rails.application.routes.draw do
  root 'static_pages#index'
  get '/popular' => 'static_pages#popular', as: :popular
  get '/cushion' => 'static_pages#cushion', as: :cushion

  get '/@:id' => 'users#show', as: :user
  get '/@:id/mine' => 'users#mine', as: :user_mine

  resources :channels, only: [:index, :show] do
    get '/:ts' => 'messages#show', ts: /[^\/]+/, as: :message
  end
end
