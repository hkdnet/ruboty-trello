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
          filtered_boards.each do |board|
            @msg.push "  ■ #{board.name}"
            filtered_lists_of(board).each do |list|
              filtered_cards_of(list).each do |card|
                @msg.push "    [#{list.name}] #{card.name}"
              end
            end
          end
        end

        def filtered_boards
          user.boards.select { |e| !keyword_include?(e) }
        end

        def filtered_lists_of(board)
          board.lists.select { |e| !keyword_include?(e) }
        end

        def filtered_cards_of(list)
          list.cards.select do |e|
            !keyword_include?(e) &&
              user_name != 'me' || e.member_ids.include?(user.id)
          end
        end

        def ignore_keywords
          @ignore_keywords ||= begin
            raw_keywords = message[:ignore_keywords]
            raw_keywords && raw_keywords != '' ? raw_keywords.split(' ') : []
          end
        end

        def keyword_include?(e)
          ignore_keywords.any? { |kw| e.name.include?(kw) }
        end
      end
    end
  end
end
