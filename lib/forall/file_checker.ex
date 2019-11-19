defmodule Forall.FileChecker do
  def child_spec(arg) do
    path = :forall |> Application.get_env(__MODULE__) |> Keyword.get(:path)
    IO.puts(path)

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
