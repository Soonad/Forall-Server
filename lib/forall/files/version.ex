defmodule Forall.Files.Version do
  @moduledoc "Calculate the hash of a file content to be used as the version"

  def version_hash(code) do
    :sha224
    |> :crypto.hash(code)
    |> Base.url_encode64(padding: false)
    |> String.slice(0..3)
  end
end
