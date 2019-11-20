defmodule Forall.Files.Bucket do
  @moduledoc """
  Upload files to an S3-api compatible object storage (such as MinIO or DO Spaces)
  """

  def upload(name, content) do
    ExAws.S3.put_object(bucket(), name, content, acl: :public_read)
    |> ExAws.request!()
  end

  defp bucket, do: Keyword.get(config(), :bucket)
  defp config, do: Application.get_env(:forall, __MODULE__)
end
