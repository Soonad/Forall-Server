defmodule ForallWeb.OpenApiSpex.SchemaHelpers do
  @moduledoc false

  alias OpenApiSpex.Schema

  def object(properties) do
    %Schema{type: :object, properties: properties}
  end

  def enum(values) do
    %Schema{type: :string, enum: values}
  end
end
