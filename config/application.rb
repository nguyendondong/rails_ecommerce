require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module EcommerceTrainning
  class Application < Rails::Application
    config.load_defaults 6.1
    config.time_zone = "Asia/Ho_Chi_Minh"
  end
end
