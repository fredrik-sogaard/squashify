Rails.application.routes.draw do

  root to: "bookings#index"

  get '/bookings/(:id)', to: 'bookings#index', as: 'day'

  get '/bot', to: 'bot#index'

end
