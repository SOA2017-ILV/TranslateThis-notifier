folders = %w[infrastructure/messaging infrastructure/email application/representers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
