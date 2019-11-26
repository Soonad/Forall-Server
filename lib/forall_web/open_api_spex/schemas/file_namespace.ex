defmodule ForallWeb.OpenApiSpex.Schemas.FileNamespace do
  @moduledoc false

  @behaviour OpenApiSpex.Schema

  def schema do
    %OpenApiSpex.Schema{
      title: "FileNamespace",
      type: :string,
      description: "The namespace of the file.",
      pattern: ~r/^[a-zA-Z0-9-_]+[a-zA-Z0-9-_\.]*$/,
      example: "public"
    }
  end
end
