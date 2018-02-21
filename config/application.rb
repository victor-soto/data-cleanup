require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DataCleanup
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join('app/scripts')

    Rails.application.config.assets.precompile += %w(
      custom/*.js
      custom/*.css
    )

    # Don't generate system test files.
    config.generators.system_tests = nil
    
  end
end
