import Config

config :forall, Forall.Repo, pool: Ecto.Adapters.SQL.Sandbox
config :forall, ForallWeb.Endpoint, server: false
config :forall, Oban, queues: false, prune: :disabled
config :logger, level: :warn
