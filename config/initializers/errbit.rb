# Require the airbrake gem in your App.
# ---------------------------------------------
#
# Rails 3 - In your Gemfile
# gem 'airbrake'
#
# Rails 2 - In environment.rb
# config.gem 'airbrake'
#
# Then add the following to config/initializers/errbit.rb
# -------------------------------------------------------

Airbrake.configure do |config|
  config.api_key = ENV['ERRBIT_API_KEY']
  config.host    = 'summer-snowflake-errbit.herokuapp.com'
  config.port    = 443
  config.secure  = config.port == 443
end
