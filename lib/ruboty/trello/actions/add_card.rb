require 'trello'

module Ruboty
  module Trello
    module Actions
      # To add a card to trello
      class AddCard < ::Ruboty::Actions::Base
        def call
          return message.reply "Board '#{message[:board_name]}' not found" if board.nil?
          return message.reply "List '#{message[:list_name]}' not found" if list.nil?

          add_card
          false
        end

        def member
          return nil unless ENV['TRELLO_AUTO_ASSIGN'] && message.from_name
          @member ||= begin
            board.members.find do |e|
              e.username.downcase == sender || e.full_name.downcase.include?(sender)
            end
          end
        end

        def sender
          message.from_name && message.from_name.downcase
        end

        def me
          @me ||= ::Trello::Member.find('me')
        end

        def board
          @board ||= me.boards.find { |e| e.name == message[:board_name] }
        end

        def list
          @list ||= board.lists.find { |e| e.name == message[:list_name] }
        end

        def add_card
          new_card = ::Trello::Card.create(name: message[:name],
                                           list_id: list.id,
                                           member_ids: member.try(:id))
          return nil unless new_card.short_url
          prefix = ENV['TRELLO_RESPONSE_PREFIX'] || 'Created'
          message.reply "#{prefix} #{new_card.short_url}"
        end
      end
    end
  end
end
