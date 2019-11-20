import Config

config :forall,
  ecto_repos: [Forall.Repo]

config :forall, Forall.Repo, migration_primary_key: [name: :id, type: :binary_id]

# Configures the endpoint
config :forall, ForallWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ForallWeb.ErrorView, accepts: ~w(html json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :forall, Oban,
  repo: Forall.Repo,
  prune: {:maxlen, 100_000},
  queues: [default: 10]

config :ex_aws,
  json_codec: Jason
