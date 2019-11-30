defmodule Forall.Files.CheckFile do
  @moduledoc """
  Job that checks the code using formality node js lib
  """

  use Oban.Worker, queue: "default", max_attempts: 10
  alias Forall.FileChecker
  alias Forall.Files.File
  alias Forall.Files.Import
  alias Forall.Files.UploadFile
  alias Forall.Repo

  import Forall.Files.Version

  @impl Oban.Worker
  def perform(%{"name" => name, "code" => code}, _job) do
    case FileChecker.check(code) do
      {:ok, imports} ->
        version = version_hash(code)

        deep_imports = Enum.map(imports, & &1.reference)

        file_changeset =
          %File{name: name, version: version}
          |> Ecto.Changeset.cast(%{}, [])
          |> Ecto.Changeset.put_embed(:deep_imports, deep_imports)
          |> Ecto.Changeset.unique_constraint(:name, name: "files_pkey")

        oban_job = UploadFile.new(%{name: name, version: version, code: code})

        domain_imports =
          imports
          |> Enum.filter(& &1.direct)
          |> Enum.map(
            &%{
              importer_name: name,
              importer_version: version,
              imported_name: &1.reference.name,
              imported_version: &1.reference.version
            }
          )

        Ecto.Multi.new()
        |> Ecto.Multi.insert(:file, file_changeset)
        |> Oban.insert(:job, oban_job)
        |> Ecto.Multi.insert_all(:imports, Import, domain_imports, on_conflict: :nothing)
        |> Repo.transaction()

      _ ->
        nil
    end
  end
end
