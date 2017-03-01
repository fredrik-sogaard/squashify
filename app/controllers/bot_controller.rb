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
    if q.downcase.include? club.name.downcase
      chosen_club = club
    end
  end

  actualdate = (date==:tomorrow) ? Date.today+1 : Date.today

  Slot.load Club.all, actualdate

  if date == :today and time == :afternoon
    datetext = t(:this_afternoon)
  elsif date == :today and time == :late
    datetext = t(:tonight)
  else
    datetext = t(date) + " " + t(time)
  end

  clubtext = chosen_club.nil? ? "" : " på #{chosen_club.name}"

  title = "Hei! Det er ledige squashtimer på følgende tidspunkter #{datetext}#{clubtext}"

  clubs = chosen_club.nil? ? Club.all : [chosen_club]
  contents = ""
  for club in clubs
    slots = Slot.all(available_hour:true, first_time: first_hour, last_time: last_hour, club: club).map{|s|s.time}.sort.uniq.join " "
    contents += "<#{club.link_url(actualdate)}|#{club.name}>: #{slots} \n "
  end
  render json: {
    response_type: "in_channel",
    text: title,
    attachments: [ { text:contents, mrkdwn_in: ["text", "pretext"] } ]
  }
end

end
