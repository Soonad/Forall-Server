defmodule Forall.Uploads.CheckFile do
  @moduledoc """
  Job that checks the code using formality node js lib
  """

  use Oban.Worker, queue: "default", max_attempts: 10
  alias Forall.FileChecker
  alias Forall.Repo
  alias Forall.Uploads.PublishFile
  alias Forall.Uploads.Upload

  @impl Oban.Worker
  def perform(args = %{"upload_id" => id, "code" => code}, _job) do
    if FileChecker.check(code) do
      args
      |> PublishFile.new()
      |> Oban.insert!()
    else
      Upload
      |> Repo.get(id)
      |> Ecto.Changeset.cast(%{error: "typecheck"}, [:error])
      |> Repo.update!()
    end
  end
end
