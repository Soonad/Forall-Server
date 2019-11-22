import Config
import ForallEnv

config :forall, Forall.Repo,
  url: get_str("DATABASE_URL"),
  pool_size: get_int("DATABASE_POOL_SIZE")

config :forall, ForallWeb.Endpoint,
  http: [port: get_int("PORT")],
  url: [
    host: get_str("PUBLIC_HOST"),
    path: get_str("PUBLIC_PATH"),
    port: get_int("PUBLIC_PORT"),
    scheme: get_str("PUBLIC_SCHEME")
  ]

config :forall, Forall.FileChecker, path: get_str("FILE_CHECKER_PATH")

config :ex_aws,
  access_key_id: get_str("BUCKET_ACCESS_KEY"),
  secret_access_key: get_str("BUCKET_SECRET_KEY")

config :ex_aws, :s3,
  scheme: get_str("BUCKET_SCHEME"),
  host: get_str("BUCKET_HOST"),
  port: get_int("BUCKET_PORT")

config :forall, Forall.Files.Bucket, bucket: get_str("BUCKET_NAME")
