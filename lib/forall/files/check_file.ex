defmodule Forall.Files.CheckFile do
  @moduledoc """
  Job that checks the code using formality node js lib
  """

  use Oban.Worker, queue: "default", max_attempts: 10
  alias Forall.FileChecker
  alias Forall.Files.File
  alias Forall.Files.UploadFile
  alias Forall.Repo

  import Forall.Files.Version

  @impl Oban.Worker
  def perform(%{"name" => name, "code" => code}, _job) do
    if FileChecker.check(code) do
      fields = %{
        name: name,
        version: version_hash(code),
        code: code
      }

      file_changeset =
        %File{}
        |> Ecto.Changeset.cast(fields, [:name, :version])
        |> Ecto.Changeset.unique_constraint(:name, name: "files_pkey")

      oban_job = UploadFile.new(fields)

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:file, file_changeset)
      |> Oban.insert(:job, oban_job)
      |> Repo.transaction()
    end
  end
end
