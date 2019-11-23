defmodule Mix.Tasks.SetupBucket do
  @moduledoc false

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:jason)
    {:ok, _} = Application.ensure_all_started(:hackney)
    {:ok, _} = Application.ensure_all_started(:ex_aws)

    :forall
    |> Application.get_env(Forall.Files.Bucket)
    |> Keyword.get(:bucket)
    |> ExAws.S3.put_bucket("region", acl: :public_read)
    |> ExAws.request()
    |> case do
      {:ok, _} ->
        :ok

      {:error, {:http_error, 409, _}} ->
        :ok

      _ ->
        raise "Could not create bucket"
    end
  end
end
