# frozen_string_literal: true

require 'sendgrid-ruby'
include SendGrid

module TranslateThis
  module Messaging
    ## Email wrapper for Sendgrid
    # Requires: sendgrid api credentials in ENV or through config file
    class Mailer
      GROUP_ID = 'TranslateThis_api'
      IDLE_TIMEOUT = 5 # seconds

      def initialize(config)
        @config = config
        @email = SendGrid::API.new(api_key: @config)
      end

      def send(message)
        recipients = ['ismaelnoble@gmail.com', 'roli.s91@gmail.com',
                      'roblescoulter@gmail.com']
        from = Email.new(email: 'notifier@translatethis.io')
        subject = "scheduled worker for :#{Time.now.to_s.split[0]}"
        content = Content.new(type: 'text/plain', value: message)
        recipients.map do |admin|
          to = Email.new(email: admin)
          mail = Mail.new(from, subject, to, content)
          @email.client.mail._('send').post(request_body: mail.to_json)
        end
      end
    end
  end
end
