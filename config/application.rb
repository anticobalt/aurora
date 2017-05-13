require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Aurora
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Stolen from stackoverflow.com/questions/32316033/convention-for-naming-poro-models-in-rails
    # Allows for POROs to be accessed like models
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
  end
end
