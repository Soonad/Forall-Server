defmodule Forall.Files.Bucket do
  @moduledoc """
  Upload files to an S3-api compatible object storage (such as MinIO or DO Spaces)
  """

  alias Forall.Files.FileReference

  @spec key_for(FileReference.t()) :: String.t()
  def key_for(%FileReference{namespace: namespace, name: name, version: version}) do
    Enum.join([namespace, name, version], "/") <> ".fm"
  end

  def upload(%FileReference{} = file_reference, content) do
    ExAws.S3.put_object(bucket(), key_for(file_reference), content, acl: :public_read)
    |> ExAws.request!()
  end

  defp bucket, do: Keyword.get(config(), :bucket)
  defp config, do: Application.get_env(:forall, __MODULE__)
end
