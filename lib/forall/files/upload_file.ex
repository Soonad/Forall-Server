defmodule Forall.Files.UploadFile do
  @moduledoc """
  After a version is assigned to a file, upload it to a bucket so it can be publicly accessible.
  """

  use Oban.Worker, queue: "default", max_attempts: 10

  alias Forall.{
    Files.Bucket,
    Uploads
  }

  @impl Oban.Worker
  def perform(
        %{"name" => name, "version" => version, "code" => code, "upload_id" => upload_id},
        _job
      ) do
    Bucket.upload("#{name}/#{version}.fm", code)
    Uploads.finish_upload!(upload_id, version)
  end
end
