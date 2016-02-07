require 'trello'

module Ruboty
  module Trello
    module Actions
      class List < ::Ruboty::Actions::Base
        def call
          msg = []
          me = ::Trello::Member.find('me')

          me.boards.each do |board|
            msg.push "■ #{board.name}"
            board.lists.each do |list|
              list.cards.each do |card|
                msg.push "[#{list.name}] #{card.name}"
              end
            end
          end

          message.reply(msg.join("\n"))
        end
      end
    end
  end
end
