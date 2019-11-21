defmodule Forall.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false

  alias Forall.Files.CheckFile
  alias Forall.Files.File
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
      file -> {:ok, file}
    end
  end
end
