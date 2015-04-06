Rails.application.routes.draw do

  root to: "bookings#index"

  get '/bookings/(:id)', to: 'bookings#index', as: 'day'

  resources :games

end
