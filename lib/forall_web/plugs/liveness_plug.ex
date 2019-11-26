defmodule Forall.LivenessPlug do
  @moduledoc """
  Simplest liveness probe
  """

  import Plug.Conn

  def init(_), do: []

  def call(%Plug.Conn{request_path: "/health/live"} = conn, _opts) do
    conn
    |> send_resp(200, "OK")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
