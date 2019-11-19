defmodule ForallWeb.OpenApiSpex.Schemas.CreateUploadRequest do
  @moduledoc false

  require OpenApiSpex

  alias ForallWeb.OpenApiSpex.Schemas.FileName
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "CreateUploadRequest",
    description: "The payload to request a new file upload",
    type: :object,
    properties: %{
      name: FileName,
      code: %Schema{type: :string, description: "The formality code for the file"}
    },
    required: [:name, :code]
  })
end
