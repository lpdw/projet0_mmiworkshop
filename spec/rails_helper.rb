require 'factory_girl_rails'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end