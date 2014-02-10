source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'capistrano'

gem 'httparty'
gem 'json'
gem 'nokogiri'

group :development do
  gem 'pry'
  gem 'awesome_print'
end

group :test do
  gem 'vcr'
  gem 'rspec'
  gem 'webmock'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
  gem 'debugger'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

gem 'endpoint_base', :git => 'git@github.com:spree/endpoint_base.git'
  # :path => '../endpoint_base'
