defmodule Forall.Releases do
  @moduledoc """
  Helper tasks to run in releases.
  """
  @app :forall

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    # Start SSL so we can connect to an SSL repo
    {:ok, _} = Application.ensure_all_started(:ssl)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
