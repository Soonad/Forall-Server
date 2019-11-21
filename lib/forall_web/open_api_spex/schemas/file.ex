defmodule ForallWeb.OpenApiSpex.Schemas.File do
  @moduledoc false

  require OpenApiSpex
  alias OpenApiSpex.Schema
  alias ForallWeb.OpenApiSpex.Schemas.{FileName, FileReference, FileVersion}

  OpenApiSpex.schema(%{
    title: "File",
    description: "A typechecked and verified file",
    type: :object,
    properties: %{
      name: FileName.schema(),
      version: FileVersion.schema(),
      cited_by: %Schema{
        description: "All the files that directly depends on this one",
        type: :array,
        items: FileReference
      },
      deep_dependencies: %Schema{
        description: "All the files that this file depends on, directly or indirectly.",
        type: :array,
        items: FileReference
      }
    },
    required: [:name, :version, :cited_by, :deep_dependencies]
  })

  def from_domain(file = %Forall.Files.File{}) do
    %__MODULE__{
      name: file.name,
      version: file.version,
      deep_dependencies: [],
      cited_by: []
    }
  end
end
