# frozen_string_literal: true

desc 'Run application console (pry)'
task :console do
  sh 'pry -r ./init.rb'
end

USERNAME = 'ismaelnoble'
IMAGE = 'translatethis-notifier'
VERSION = '0.1.0'
WORKER_APP = 'ruby application/load_notifier.rb'

desc 'Build Docker image'
task :worker do
  sh WORKER_APP
end

# Docker tasks
namespace :docker do
  desc 'Build Docker image'
  task :build do
    puts "\nBUILDING WORKER IMAGE"
    sh "docker build --force-rm -t #{USERNAME}/#{IMAGE}:#{VERSION} ."
  end

  desc 'Run the local Docker container as a worker'
  task :run do
    env = ENV['WORKER_ENV']

    puts "\nRUNNING WORKER WITH LOCAL CONTEXT"
    puts " Running in #{env} mode"

    sh 'docker run -e WORKER_ENV -v $(pwd)/config:/worker/config --rm -it ' \
       "#{USERNAME}/#{IMAGE}:#{VERSION}"
  end

  desc 'Remove exited containers'
  task :rm do
    sh 'docker rm -v $(docker ps -a -q -f status=exited)'
  end

  desc 'List all containers, running and exited'
  task :ps do
    sh 'docker ps -a'
  end

  # desc 'Push Docker image to Docker Hub'
  # task :push do
  #   puts "\nPUSHING IMAGE TO DOCKER HUB"
  #   sh "docker push #{USERNAME}/#{IMAGE}:#{VERSION}"
  # end
end

# Heroku container registry tasks
namespace :heroku do
  desc 'Build and Push Docker image to Heroku Container Registry'
  task :push do
    puts "\nBUILDING + PUSHING IMAGE TO HEROKU"
    sh 'heroku container:push web'
  end

  desc 'Run worker on Heroku'
  task :run do
    puts "\nRUNNING CONTAINER ON HEROKU"
    sh 'heroku run rake worker'
  end
end
