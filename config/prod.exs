import Config

config :forall, Forall.Repo,
  show_sensitive_data_on_connection_error: false,
  ssl: true,
  pool_size: 10

config :forall, ForallWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"
config :logger, level: :info
