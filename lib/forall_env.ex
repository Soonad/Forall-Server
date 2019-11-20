defmodule ForallEnv do
  @moduledoc """
  Utility module that helps with environment variables on configs.
  """

  def get_str(name) do
    case System.get_env(name) do
      nil ->
        raise "Env var #{name} is not defined."

      value ->
        value
    end
  end

  def get_int(name) do
    String.to_integer(get_str(name))
  end

  def get_atom(name) do
    String.to_atom(get_str(name))
  end
end
