defmodule ForallWeb.OpenApiSpex.Schemas.PublishFileResponse do
  @moduledoc false

  require OpenApiSpex

  alias ForallWeb.OpenApiSpex.Schemas.FileName
  alias ForallWeb.OpenApiSpex.Schemas.FileVersion

  OpenApiSpex.schema(%{
    title: "PublishFileResponse",
    description: "The response of a file publication request",
    type: :object,
    properties: %{
      name: FileName.schema(),
      version: FileVersion.schema()
    },
    required: [:name, :version]
  })
end
