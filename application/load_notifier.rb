# frozen_string_literal: true

require 'econfig'
require 'aws-sdk-sqs'

require_relative '../init.rb'

extend Econfig::Shortcut
Econfig.env = ENV['WORKER_ENV'] || 'development'
Econfig.root = File.expand_path('..', File.dirname(__FILE__))

ENV['AWS_ACCESS_KEY_ID'] = config.AWS_ACCESS_KEY_ID
ENV['AWS_SECRET_ACCESS_KEY'] = config.AWS_SECRET_ACCESS_KEY
ENV['AWS_REGION'] = config.AWS_REGION

queue = TranslateThis::Messaging::Queue.new(config.NOTIFY_QUEUE_URL)
notifications = {}

puts 'Checking reported notifications'
queue.poll do |notification_request|
  notification = notification_request
  time = notification.split(/\s /).first
  hash = notification.split(/\s /).last
  notifications[hash] = time
  print '.'
end

# Notify administrator of unique clones
if notifications.count > 0
  # TODO: Email administrator instead of printing to STDOUT
  puts "\nNumber of unique image requests: #{notifications.count}"
  # TODO: Setup output for this month we had x requests.
else
  puts 'No new images sent =('
end
