defmodule Forall.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false

  alias Forall.Files.CheckFile
  alias Forall.Files.File
  alias Forall.Files.FileReference
  alias Forall.Files.Import
  alias Forall.Repo

  import Forall.Files.Version

  @spec publish_file(String.t(), String.t()) ::
          {:ok, String.t()}
  def publish_file(name, code) do
    %{name: name, code: code}
    |> CheckFile.new()
    |> Oban.insert!()

    {:ok, version_hash(code)}
  end

  @spec get_file(String.t(), String.t()) :: {:ok, File.t()} | {:error, :not_found}
  def get_file(name, version) do
    case Repo.one(File.get_query(name, version)) do
      nil -> {:error, :not_found}
      file -> {:ok, load_imported_by(file)}
    end
  end

  @spec load_imported_by(File.t()) :: File.t()
  defp load_imported_by(file) do
    %File{file | imported_by: imported_by(file.name, file.version)}
  end

  @spec imported_by(String.t(), String.t()) :: [FileReference.t()]
  defp imported_by(name, version) do
    name
    |> Import.get_imported_by(version)
    |> Repo.all()
    |> Enum.map(&%FileReference{name: &1.importer_name, version: &1.importer_version})
  end
end
