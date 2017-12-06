Rails.application.routes.draw do
  root to: 'users#signin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/auth/spotify/callback', to: 'users#spotify'
end
