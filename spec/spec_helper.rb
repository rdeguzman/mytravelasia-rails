require 'rubygems'
require 'spork'

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    config.include Devise::TestHelpers, :type => :controller

    config.color_enabled = true
    config.filter_run :focus => true
    config.filter_run_excluding :wip => true
    config.run_all_when_everything_filtered = true

    #Capybara.javascript_driver = :selenium_chromium
    Capybara.javascript_driver = :selenium_chromium

    Capybara.default_wait_time = 5

    # We will need to have the selenium driver for Google Chrome
    # 1. Download from http://code.google.com/p/chromedriver/downloads/list
    # 2. cp chromedriver /usr/bin
    # 3. Create a symobolic link for the Google Chrome binary:
    #  /usr/bin/google-chrome@ -> /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
    # Unable to install chromedriver in FREEBSD
    Capybara.register_driver :selenium_chromium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  
end