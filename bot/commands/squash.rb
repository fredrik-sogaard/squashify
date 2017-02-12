module EyBot
  module Commands
    class Squash < SlackRubyBot::Commands::Base
      match /(S|s)quash/ do |client, data, _match|

        q = data[:text].downcase

        if q.include? "i morgen" or q.include? "imorgen" or q.include? "i morra"
          date = :tomorrow
        else
          date = :today
        end

        if q.include? "tidlig" or q.include? "formiddag"
          time = :early
          first_hour = nil
          last_hour = 16
        else
          time = :afternoon
          first_hour = 16
          last_hour = nil
        end

        for club in Club.all
          if q.downcase.include? club.name.downcase
            chosen_club = club
          end
        end

        actualdate = (date==:tomorrow) ? Date.today+1 : Date.today

        Slot.load actualdate

        if date == :today
          if time == :afternoon
            datetext = 'i dag fra 16'
          else
            datetext = 'i dag før 16'
          end
        else
          if time == :afternoon
            datetext = 'i morgen fra 16'
          else
            datetext = 'i morgen før 16'
          end
        end

        clubtext = chosen_club.nil? ? "" : " på #{chosen_club.name}"

        title = "Det er ledige squashtimer på følgende tidspunkter #{datetext}#{clubtext}"

        clubs = chosen_club.nil? ? Club.all : [chosen_club]
        contents = ""
        for club in clubs
          slots = Slot.all(available_hour:true, first_time: first_hour, last_time: last_hour, club: club).map{|s|s.time}.sort.uniq.join " "
          contents += "<#{club.link_url(actualdate)}|#{club.name}>: #{slots} \n "
        end

        client.web_client.chat_postMessage(
          channel: data.channel,
          as_user: true,
          text: title,
          attachments: [ { text:contents, mrkdwn_in: ["text", "pretext"] } ].to_json
        )

      end
    end
  end
end
