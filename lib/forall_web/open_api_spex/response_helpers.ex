defmodule ForallWeb.OpenApiSpex.ResponseHelpers do
  @moduledoc false

  alias OpenApiSpex.MediaType
  alias OpenApiSpex.Operation
  alias OpenApiSpex.RequestBody
  alias OpenApiSpex.Response

  def empty_response(description) do
    %Response{description: description}
  end

  def response(description, schema_ref_or_nil \\ nil, opts \\ []) do
    %Response{
      description: description,
      content: content_for(schema_ref_or_nil, opts),
      headers: opts[:headers]
    }
  end

  def request_body(description, schema_ref, opts \\ []) do
    %RequestBody{
      description: description,
      content: content_for(schema_ref, opts),
      required: opts[:required]
    }
  end

  defdelegate parameter(name, location, type, description, opts \\ []), to: Operation

  defp content_for(nil, _opts), do: nil

  defp content_for(schema_ref, opts) do
    %{
      Keyword.get(opts, :media_type, "application/json") => %MediaType{
        schema: schema_ref,
        example: opts[:example],
        examples: opts[:examples]
      }
    }
  end
end
