defmodule Forall.Uploads do
  @moduledoc """
  The Uploads context.
  """

  import Ecto.Query, warn: false
  alias Forall.Repo

  alias Forall.Uploads.File
  alias Forall.Uploads.Upload

  def get_finished_upload(id) do
    case Repo.get(published_uploads(), id) do
      nil -> {:error, :not_found}
      upload -> {:ok, upload}
    end
  end

  @spec create_upload(String.t(), String.t()) :: String.t()
  def create_upload(name, _code) do
    Repo.insert!(%Upload{name: name}).id
  end

  def get_file(name, version) do
    case Repo.one(file_query(name, version)) do
      nil -> {:error, :not_found}
      file -> {:ok, file}
    end
  end

  defp published_uploads do
    from(u in Upload, where: not is_nil(u.version))
  end

  defp file_query(name, version) do
    from(f in File, where: f.name == ^name and f.version == ^version)
  end
end
