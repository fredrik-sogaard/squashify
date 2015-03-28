Rails.application.routes.draw do

  root to: "look#index"

  get '/look/:id', to: 'look#index', as: 'day'

end
