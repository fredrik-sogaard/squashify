module EyBot
  module Commands
    class Calculate < SlackRubyBot::Commands::Base
      command 'calculate' do |client, data, _match|
        client.say(channel: data.channel, text: '5')
      end
    end
  end
end
