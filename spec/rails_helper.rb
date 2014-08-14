ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/email/rspec'
#require 'rspec/autorun'

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.start do
  add_filter 'factories'

  add_group 'Models', 'models'
  add_group 'Controllers', 'controllers'
  add_group 'Helpers', 'helpers'
  add_group 'Views', 'views'
  add_group 'Mailers', 'mailers'
  add_group 'Libraries', 'lib'
  add_group 'Routing', 'routing'
  add_group 'Features', 'features'
  add_group 'Workers', 'workers'
  #add_group 'Requests', 'requests'
end

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

include Warden::Test::Helpers
Warden.test_mode!

Capybara.javascript_driver = :webkit
Capybara.default_wait_time = 5
Capybara.register_driver :selenium do |app|
  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.timeout = 100
  Capybara::Selenium::Driver.new(app, browser: :firefox, http_client: http_client)
end

RSpec.configure do |config|
  # Use FactoryGirl
  Spork.each_run do
    FactoryGirl.reload
  end
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL

  config.use_transactional_fixtures = false
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Use Devise Test Helper
  config.include Devise::TestHelpers, type: :controller

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  #config.before(:suite) do
  #  DatabaseCleaner.strategy = :truncation
  #  DatabaseCleaner.clean_with(:truncation)
  #end

  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false

  config.include LoginMacros
end
