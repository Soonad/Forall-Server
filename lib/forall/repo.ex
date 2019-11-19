defmodule Forall.Repo do
  use Ecto.Repo,
    otp_app: :forall,
    adapter: Ecto.Adapters.Postgres
end
