class BotController < ApplicationController

def index

  q = params[:text]

  if q.include? "i morgen" or q.include? "imorgen"
    date = :tomorrow
  else
    date = :today
  end

  if q.include? "tidlig" or q.include? "formiddag"
    time = :early
    first_hour = nil
    last_hour = 12
  elsif q.include? "ettermiddag" or q.include? "etter jobb"
    time = :afternoon
    first_hour = 15
    last_hour = 20
  else
    time = :late
    first_hour = 20
    last_hour = nil
  end

  for club in Club.all
    if q.include? club.name
      chosen_club = club
    end
  end

  Slot.load (date==:tomorrow) ? Date.today+1 : Date.today

  if date == :today and time == :afternoon
    datetext = t(:this_afternoon)
  elsif date == :today and time == :late
    datetext = t(:tonight)
  else
    datetext = t(date) + " " + t(time)
  end


  title = "Hei! Det er ledige squashtimer på følgende tidspunkter #{datetext}"

  contents = ""

  clubs = chosen_club.nil? ? Club.all : [chosen_club]
  fields = []
  for club in clubs
    slots = Slot.all(available_hour:true, first_time: first_hour, last_time: last_hour, club: club).map{|s|s.time}.sort.uniq.join " "
     fields << {title:club.name, value:slots}
  end
  render json: {
    response_type: "in_channel",
    text: title,
    attachments: [ { fields:fields } ]
  }
end

end
