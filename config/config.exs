# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rover,
  ecto_repos: [Rover.Repo]

# Configures the endpoint
config :rover, RoverWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6cGSUFk/KTAWw9vJdDSjdo8pjQ3m3A8t/gp1KgdCUMWr0j4bLAhK4OjvHnCTkdlt",
  render_errors: [view: RoverWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Rover.PubSub,
  live_view: [signing_salt: "g0u5NG65"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
