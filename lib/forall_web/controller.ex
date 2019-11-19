defmodule ForallWeb.Controller do
  @moduledoc """
  A controller that makes easy to document the API with OpenAPI Spec 3
  """

  alias OpenApiSpex.Operation

  defmacro doc(name, args) do
    quote do
      @open_api_spex_operations {unquote(name),
                                 unquote(__MODULE__).__build_operation__(unquote(args))}
    end
  end

  @spec casted_body(Plug.Conn.t()) :: term()
  def casted_body(conn) do
    # The `OpenApiSpex.Plug.CastAndValidate` plug put things on body_params, but body_params is
    # typed as a map from string to term, so it causes dialyzer errors. To avoid that, I'll be using
    # this function to hide the implementation details.
    conn.body_params
  end

  defmacro __using__(_) do
    quote do
      use Phoenix.Controller, namespace: ForallWeb

      @before_compile unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :open_api_spex_operations, accumulate: true)

      import Plug.Conn

      import unquote(__MODULE__)
      import ForallWeb.OpenApiSpex.ResponseHelpers
      import ForallWeb.OpenApiSpex.SchemaHelpers
    end
  end

  defmacro __before_compile__(_) do
    quote do
      @spec open_api_operation(any) :: unquote(Operation).t()
      def open_api_operation(action) do
        Keyword.get(@open_api_spex_operations, action)
      end
    end
  end

  def __build_operation__(opts) do
    struct!(
      Operation,
      Enum.map(opts, fn {k, v} ->
        {k |> to_string() |> to_lower_camel_case() |> String.to_existing_atom(), v}
      end)
    )
  end

  defp to_lower_camel_case(snake_case) do
    {first, rest} = snake_case |> Macro.camelize() |> String.split_at(1)
    String.downcase(first) <> rest
  end
end
