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

  @spec publish_file(String.t(), String.t(), String.t()) ::
          {:ok, FileReference.t()}
  def publish_file(namespace, name, code) do
    %{namespace: namespace, name: name, code: code}
    |> CheckFile.new()
    |> Oban.insert!()

    {:ok,
     %FileReference{
       namespace: namespace,
       name: name,
       version: version_hash(code)
     }}
  end

  @spec get_file(FileReference.t()) :: {:ok, File.t()} | {:error, :not_found}
  def get_file(%FileReference{} = file_reference) do
    case Repo.one(File.get_query(file_reference)) do
      nil -> {:error, :not_found}
      file -> {:ok, load_imported_by(file)}
    end
  end

  @spec load_imported_by(File.t()) :: File.t()
  defp load_imported_by(file) do
    %File{file | imported_by: file |> File.reference() |> imported_by()}
  end

  @spec imported_by(FileReference.t()) :: [FileReference.t()]
  defp imported_by(%FileReference{} = file_reference) do
    file_reference
    |> Import.by_imported()
    |> Repo.all()
    |> Enum.map(&Import.importer_reference/1)
  end
end
