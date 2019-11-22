import Config

config :forall, ForallWeb.Endpoint, server: true

config :forall, Forall.Repo,
  show_sensitive_data_on_connection_error: false,
  ssl: true

config :logger, level: :info
