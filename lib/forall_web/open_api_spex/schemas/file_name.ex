defmodule ForallWeb.OpenApiSpex.Schemas.FileName do
  @moduledoc false

  @behaviour OpenApiSpex.Schema

  def schema do
    %OpenApiSpex.Schema{
      title: "FileName",
      type: :string,
      description: "The name of the file.",
      pattern: ~r/^[a-zA-Z0-9-_]+(\\.[a-zA-Z0-9-_]+)*$/,
      example: "MyFile.Name"
    }
  end
end
