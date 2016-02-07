require 'trello'

module Ruboty
  module Trello
    module Actions
      class List < ::Ruboty::Actions::Base
        def call
          user_name = message[:user_name] || 'me'
          user = ::Trello::Member.find(user_name)
          msg = []
          if user.nil?
            return message.reply("User '#{user_name}' not found")
          else
            msg.push("#{user_name}'s task...")
          end
          user.boards.each do |board|
            msg.push "  ■ #{board.name}"
            board.lists.each do |list|
              list.cards.each do |card|
                next if message[:assigned_only] && !card.member_ids.include?(user.id)
                msg.push "    [#{list.name}] #{card.name}"
              end
            end
          end
          message.reply(msg.join("\n"))
          false
        end
      end
    end
  end
end
