defmodule ForallWeb.OpenApiSpex.Schemas.FileVersion do
  @moduledoc false

  @behaviour OpenApiSpex.Schema

  def schema do
    %OpenApiSpex.Schema{
      title: "FileVersion",
      type: :string,
      description: "The assigned version of the file.",
      example: "0"
    }
  end
end
