# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv/load'
Dir['./lita/**/*.rb'].each { |file| require file }

Lita.configure do |config|
  if ENV['RACK_ENV'] == 'production'
    config.redis[:url]     = ENV['REDIS_URL']
    config.robot.adapter   = :slack
    config.robot.log_level = :info
  else
    config.redis           = { host: '127.0.0.1', port: 6379 }
    config.robot.adapter   = :shell
    config.robot.log_level = :debug
  end

  # general config
  config.robot.name   = 'houston'
  config.robot.locale = :en
  config.http.port    = ENV['HTTP_PORT']

  # slack config
  config.adapters.slack.token      = ENV['SLACK_TOKEN']
  config.adapters.slack.link_names = true
  config.adapters.slack.parse      = 'full'
end
