# frozen_string_literal: true

module Lita
  module Handlers
    class HelloHandler < Handler
      route(/^hello/) do |response|
        response.reply 'Hi'
      end
    end

    Lita.register_handler(HelloHandler)
  end
end
