defmodule Forall.FileChecker do
  @moduledoc """
  Calls formality to check the code is valid, typechecked and all definitions are annotated.
  """

  def child_spec(arg) do
    path = :forall |> Application.get_env(__MODULE__) |> Keyword.get(:path)

    %{
      id: NodeJS,
      start: {NodeJS, :start_link, [Keyword.put(arg, :path, path)]},
      shutdown: :infinity,
      type: :supervisor
    }
  end

  def check(code) do
    NodeJS.call!("check", [code])
  end
end
