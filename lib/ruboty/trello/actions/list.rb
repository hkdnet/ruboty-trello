require 'trello'

module Ruboty
  module Trello
    module Actions
      # list tasks in trello
      class List < ::Ruboty::Actions::Base
        def call
          @msg = []
          return message.reply("User '#{user_name}' not found") if user.nil?
          @msg.push("#{user_name}'s task...")
          build_msg
          message.reply(@msg.join("\n"))
          false
        end

        def user_name
          message[:user_name] || 'me'
        end

        def user
          @user ||= ::Trello::Member.find(user_name)
        end

        def build_msg
          user.boards.each do |board|
            @msg.push "  ■ #{board.name}"
            board.lists.each do |list|
              list.cards.select { |e| filter_message(e) }.each do |card|
                @msg.push "    [#{list.name}] #{card.name}"
              end
            end
          end
        end

        def filter_message(card)
          user_name != 'me' || card.member_ids.include?(user.id)
        end
      end
    end
  end
end
