defmodule Forall.Uploads do
  @moduledoc """
  The Uploads context.
  """

  import Ecto.Query, warn: false
  alias Forall.Repo

  alias Forall.Uploads.CheckFile
  alias Forall.Uploads.Upload

  @spec get_upload(String.t()) :: {:ok, Upload.t()} | {:error, :not_found}
  def get_upload(id) do
    case Repo.get(Upload, id) do
      nil -> {:error, :not_found}
      upload -> {:ok, upload}
    end
  end

  @spec create_upload(String.t(), String.t()) :: {:ok, Upload.t()}
  def create_upload(name, code) do
    Repo.transaction(fn ->
      upload = Repo.insert!(%Upload{name: name})

      %{upload_id: upload.id, code: code}
      |> CheckFile.new()
      |> Oban.insert!()

      upload
    end)
  end

  def finish_upload!(id, version) do
    Upload
    |> Repo.get(id)
    |> Ecto.Changeset.cast(%{version: version}, [:version])
    |> Repo.update!()
  end
end
