import Config

config :forall,
  ecto_repos: [Forall.Repo]

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
