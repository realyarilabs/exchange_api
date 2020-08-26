# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :exchange_api,
  ecto_repos: [ExchangeApi.Repo]

config :exchange_api, ExchangeApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "alchemist",
  hostname: "localhost",
  pool_size: 10

config :exchange_api, ExchangeApi.Guardian,
  issuer: "exchange_api",
  secret_key: "QXYv3bQuBX8zKhtPiNSrzf+W/zVMSRxcXdRJYWCTo6xo4l3LAgs2C+md84u/sP2n"

# Configures the endpoint
config :exchange_api, ExchangeApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q7M5uE+1YBDZGeuuk462bNxTsEk1SW1yaY75DzP3DnCdn9KQN+Y2zbXI5aUY4AMz",
  render_errors: [view: ExchangeApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExchangeApi.PubSub,
  live_view: [signing_salt: "9oQrITxU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :exchange,
  message_bus_adapter: Exchange.Adapters.EventBus,
  time_series_adapter: Exchange.Adapters.InMemoryTimeSeries,
  tickers: [{:AUXLND, :GBP, 1000, 100_000}, {:AGUS, :USD, 1000, 100_000}]
