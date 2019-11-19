import Config

config :forall, Forall.Repo, pool: Ecto.Adapters.SQL.Sandbox
config :forall, ForallWeb.Endpoint, server: false
config :logger, level: :warn
