defmodule Forall.FileChecker do
  @moduledoc """
  Calls formality to check the code is valid, typechecked and all definitions are annotated.
  """

  alias Forall.Files.FileReference

  @type fm_import :: %{
          namespace: String.t(),
          name: String.t(),
          version: String.t(),
          direct: boolean()
        }

  def child_spec(arg) do
    path = :forall |> Application.get_env(__MODULE__) |> Keyword.get(:path)

    %{
      id: NodeJS,
      start: {NodeJS, :start_link, [Keyword.put(arg, :path, path)]},
      shutdown: :infinity,
      type: :supervisor
    }
  end

  @spec check(String.t()) :: {:ok, [fm_import()]} | :error
  def check(code) do
    case NodeJS.call!("check", [code]) do
      %{"typechecks" => true, "imports" => imports} ->
        {:ok, Enum.map(imports, &parse_import/1)}

      _ ->
        :error
    end
  end

  defp parse_import(%{
         "namespace" => namespace,
         "name" => name,
         "version" => version,
         "direct" => direct
       }) do
    %{
      reference: %FileReference{namespace: namespace, name: name, version: version},
      direct: direct
    }
  end
end
