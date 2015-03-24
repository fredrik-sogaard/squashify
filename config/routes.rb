Rails.application.routes.draw do

  root to: "look#available"

  get 'look/index'
  get 'look/available'

end
