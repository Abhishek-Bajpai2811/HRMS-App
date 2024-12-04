# require_relative "boot"

# require "rails/all"

# # Require the gems listed in Gemfile, including any gems
# # you've limited to :test, :development, or :production.
# Bundler.require(*Rails.groups)

# module First
#   class Application < Rails::Application
#     # Initialize configuration defaults for originally generated Rails version.
#     config.load_defaults 7.2

#     # Please, add to the `ignore` list any other `lib` subdirectories that do
#     # not contain `.rb` files, or that should not be reloaded or eager loaded.
#     # Common ones are `templates`, `generators`, or `middleware`, for example.
#     config.autoload_lib(ignore: %w[assets tasks])

#     # Configuration for the application, engines, and railties goes here.
#     #
#     # These settings can be overridden in specific environments using the files
#     # in config/environments, which are processed later.
#     #
#     # config.time_zone = "Central Time (US & Canada)"
#     # config.eager_load_paths << Rails.root.join("extras")
#   end
# end


require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsProjectMain
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Configure session storage using cookies with a custom key.
    config.session_store :cookie_store, key: '_hrmitra_session'

    # Add directories under `lib` to the autoload paths. Modify `ignore` as needed.
    config.autoload_lib(ignore: %w[assets tasks])

    config.action_controller.raise_on_missing_callback_actions = false

    # Set a default time zone (example: Central Time for US & Canada).
    # Uncomment and set your time zone if needed.
    # config.time_zone = "Central Time (US & Canada)"

    # Set default locale (example: English). Uncomment and set your locale if needed.
    # config.i18n.default_locale = :en

    # Enable custom eager load paths (for any additional directories).
    # Example: config.eager_load_paths << Rails.root.join("extras")
    # Uncomment and modify if you have such directories.
    # config.eager_load_paths << Rails.root.join("lib", "services")

    # Configure Active Job queue adapter (default is async).
    # Example: config.active_job.queue_adapter = :sidekiq
    # Uncomment and modify if using a job queue like Sidekiq or Resque.
    # config.active_job.queue_adapter = :sidekiq

    # Handle API-only mode (if you're building an API).
    # Uncomment the following if you want to use Rails as an API-only application:
    # config.api_only = true

    # Prevent unnecessary assets, helpers, and routes from being generated.
    config.generators do |g|
      g.assets false        # Skip generating CSS/JS files
      g.helper false        # Skip generating helper files
      g.test_framework :rspec, fixtures: false # Use RSpec without fixtures
    end



    # Middleware settings for additional security or optimizations.
    # Uncomment and modify to add custom middleware (like Rack::Attack or CORS settings).
    # config.middleware.use Rack::Attack

    # Enable or disable cross-origin resource sharing (CORS) for API mode.
    # Uncomment the following if building an API:
    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins '*' # Or specific origins
    #     resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete, :options, :head]
    #   end
    # end
  end
end
