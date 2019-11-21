defmodule Forall.Files.UploadFile do
  @moduledoc """
  After a version is assigned to a file, upload it to a bucket so it can be publicly accessible.
  """

  use Oban.Worker, queue: "default", max_attempts: 10

  alias Forall.Files.Bucket

  @impl Oban.Worker
  def perform(
        %{"name" => name, "version" => version, "code" => code},
        _job
      ) do
    Bucket.upload("#{name}/#{version}.fm", code)
  end
end
