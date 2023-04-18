require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppBrokers
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.assets.initialize_on_precompile = false
    config.serve_static_assets = true
    config.generators do |g|
      g.factory_bot false
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # Load dotenv only in development or test environment
    if ['development', 'test'].include? ENV['RAILS_ENV']
      Dotenv::Railtie.load
    end

    HOSTNAME = ENV['HOSTNAME']

  end
end
