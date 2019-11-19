defmodule ForallWeb.OpenApiSpex.Schemas.FileReference do
  @moduledoc false

  require OpenApiSpex
  alias ForallWeb.OpenApiSpex.Schemas.{FileName, FileVersion}

  OpenApiSpex.schema(%{
    title: "FileReference",
    description: "A reference to a file composed by name and version",
    type: :object,
    properties: %{
      name: FileName.schema(),
      version: FileVersion.schema()
    },
    required: [:name, :version]
  })
end
