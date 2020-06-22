# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :relayman, RelaymanWeb.Endpoint,
  secret_key_base: "a8ltX4m+C7GTfdc4ipR+oezd6mXBvwxPsAV1tE03iQcUudPot7eDU2v+uBBszIur",
  render_errors: [view: RelaymanWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: RelaymanWeb.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
