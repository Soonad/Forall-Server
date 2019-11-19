import Config
import ForallEnv

config :forall, Forall.Repo, url: get_str("DATABASE_URL")

config :forall, ForallWeb.Endpoint, http: [port: get_int("PORT")]

config :forall, Forall.FileChecker, path: get_str("FILE_CHECKER_PATH")
