require 'ruboty'
require 'ruboty/trello/version'
require 'ruboty/trello/actions/add_card'
require 'trello'
Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

module Ruboty
  module Handlers
    class Trello < Base
      on /trello\s+b\s+(?<board_name>.*)\s+l\s+(?<list_name>.*)\s+c\s+(?<name>.*)\z/i, name: 'add_card', description: 'Add card to Trello'

      def add_card(message)
        Ruboty::Trello::Actions::AddCard.new(message).call
      end
    end
  end
end
