defmodule Forall.LivenessPlug do
  @moduledoc """
  Simplest liveness probe
  """

  import Plug.Conn

  def init(_), do: []

  def call(conn = %Plug.Conn{request_path: "/health/live"}, _opts) do
    conn
    |> send_resp(200, "OK")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
