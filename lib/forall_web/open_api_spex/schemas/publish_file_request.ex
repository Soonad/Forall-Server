defmodule ForallWeb.OpenApiSpex.Schemas.PublishFileRequest do
  @moduledoc false

  require OpenApiSpex

  alias ForallWeb.OpenApiSpex.Schemas.FileName
  alias ForallWeb.OpenApiSpex.Schemas.FileNamespace
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "PublishFileRequest",
    description: "The payload to request a new file publication",
    type: :object,
    properties: %{
      namespace: FileNamespace.schema(),
      name: FileName.schema(),
      code: %Schema{type: :string, description: "The formality code for the file"}
    },
    required: [:name, :code]
  })
end
