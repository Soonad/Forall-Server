defmodule Forall.Files.UploadFile do
  @moduledoc """
  After a version is assigned to a file, upload it to a bucket so it can be publicly accessible.
  """

  use Oban.Worker, queue: "default", max_attempts: 10

  alias Forall.Files.Bucket
  alias Forall.Files.FileReference

  @impl Oban.Worker
  def perform(
        %{"namespace" => namespace, "name" => name, "version" => version, "code" => code},
        _job
      ) do
    Bucket.upload(%FileReference{namespace: namespace, name: name, version: version}, code)
  end
end
