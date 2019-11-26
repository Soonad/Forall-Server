defmodule ForallWeb.OpenApiSpex.Schemas.File do
  @moduledoc false

  require OpenApiSpex
  alias Forall.Files.File, as: DomainFile
  alias ForallWeb.OpenApiSpex.Schemas.FileReference
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "File",
    description: "A typechecked and verified file",
    type: :object,
    properties: %{
      reference: FileReference,
      imported_by: %Schema{
        description: "All the files that directly depends on this one",
        type: :array,
        items: FileReference
      },
      deep_imports: %Schema{
        description: "All the files that this file depends on, directly or indirectly.",
        type: :array,
        items: FileReference
      }
    },
    required: [:reference, :imported_by, :deep_imports]
  })

  def from_domain(%DomainFile{} = file) do
    %__MODULE__{
      reference: file |> DomainFile.reference() |> FileReference.from_domain(),
      deep_imports: Enum.map(file.deep_imports, &FileReference.from_domain/1),
      imported_by: Enum.map(file.imported_by || [], &FileReference.from_domain/1)
    }
  end
end
