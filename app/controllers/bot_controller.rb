class BotController < ApplicationController

def index

  render json: {
    response_type: "in_channel",
    text: "Hei " + params[:user_name],
    attachments: [ { text:"Hallo hallo" } ]
  }
end

end
