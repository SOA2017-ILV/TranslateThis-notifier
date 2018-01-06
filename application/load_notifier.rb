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
ENV['SENDGRID_KEY'] = config.SENDGRID_KEY

queue = TranslateThis::Messaging::Queue.new(config.NOTIFY_QUEUE_URL)
notifications = {}
puts 'Checking reported notifications'
queue.poll do |notification_request|
  notification = notification_request
  time = notification.split(/\s /).first
  url = notification.split(/\s /).last
  notifications[url] = time
  print '.'
end
# Notify administrator of unique clones
if notifications.count > 0
  message = "\nNumber of unique image requests: #{notifications.count}"
  emailer = TranslateThis::Messaging::Mailer.new(config.SENDGRID_KEY)
  emailer.send(message)
  puts message
  puts notifications
  # TODO: Setup output for this month we had x requests.
else
  message = 'No new images sent =('
  emailer = TranslateThis::Messaging::Mailer.new(config.SENDGRID_KEY)
  emailer.send(message)
  puts message
end
