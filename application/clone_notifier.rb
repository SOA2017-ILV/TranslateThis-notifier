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

queue = TranslateThis::Messaging::Queue.new(config.REPORT_QUEUE_URL)
#cloned_repos = {}

# puts 'Checking reported clones'
# queue.poll do |clone_request_json|
#   clone_request = CodePraise::CloneRequestRepresenter
#                   .new(OpenStruct.new)
#                   .from_json(clone_request_json)
#   cloned_repos[clone_request.repo.origin_id] = clone_request.repo
#   print '.'
# end
#
# # Notify administrator of unique clones
# if cloned_repos.count > 0
#   total_size = cloned_repos.values.reduce(0) do |size, repo|
#     size += repo.size
#   end
#
#   # TODO: Email administrator instead of printing to STDOUT
#   puts "\nNumber of unique repos cloned: #{cloned_repos.count}"
#   puts "Total disk space: #{total_size}"
# else
#   puts "No cloning reported"
# end
