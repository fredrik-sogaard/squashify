class BotController < ApplicationController

def index
  render json: {
    response_type: "in_channel",
    text: "Hei!",
    attachments: [ { text:"Hallo hallo" } ]
  }
end

end
