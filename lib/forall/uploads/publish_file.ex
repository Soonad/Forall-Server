defmodule Forall.Uploads.PublishFile do
  @moduledoc """
  Job that pubishes a file after it has been verified.
  """

  use Oban.Worker, queue: "default", max_attempts: 10

  alias Forall.{
    Files,
    Repo,
    Uploads.Upload
  }

  @impl Oban.Worker
  def perform(%{"upload_id" => upload_id, "code" => code}, _job) do
    upload = Repo.get(Upload, upload_id)

    with {:error, :hash_collision} <- Files.publish_file(upload.name, code, upload_id) do
      upload
      |> Ecto.Changeset.cast(%{error: "hash_collision"}, [:error])
      |> Repo.update!()
    end
  end
end
