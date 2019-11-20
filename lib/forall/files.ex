defmodule Forall.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false

  alias Forall.Files.File
  alias Forall.Files.UploadFile
  alias Forall.Repo

  @spec publish_file(String.t(), String.t(), String.t()) ::
          {:ok, File.t()} | {:error, :hash_collision}
  def publish_file(name, code, upload_id) do
    fields = %{
      name: name,
      version: version_hash(code),
      upload_id: upload_id,
      code: code
    }

    file_changeset =
      %File{}
      |> Ecto.Changeset.cast(fields, [:name, :version, :upload_id])
      |> Ecto.Changeset.unique_constraint(:name, name: "files_pkey")

    oban_job = UploadFile.new(fields)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:file, file_changeset)
    |> Oban.insert(:job, oban_job)
    |> Repo.transaction()
    |> case do
      {:ok, %{file: file}} ->
        {:ok, file}

      {:error, :file, %{errors: [{:name, _}]}} ->
        {:ok, file} = get_file(name, fields.version)

        if file.upload_id == upload_id do
          {:ok, file}
        else
          {:error, :hash_collision}
        end
    end
  end

  @spec get_file(String.t(), String.t()) :: {:ok, File.t()} | {:error, :not_found}
  def get_file(name, version) do
    case Repo.one(file_query(name, version)) do
      nil -> {:error, :not_found}
      file -> {:ok, file}
    end
  end

  defp file_query(name, version) do
    from(f in File, where: f.name == ^name and f.version == ^version)
  end

  def version_hash(code) do
    :sha224
    |> :crypto.hash(code)
    |> Base.url_encode64(padding: false)
    |> String.slice(0..3)
  end
end
