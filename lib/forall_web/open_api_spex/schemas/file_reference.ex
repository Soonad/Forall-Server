defmodule ForallWeb.OpenApiSpex.Schemas.FileReference do
  @moduledoc false

  require OpenApiSpex
  alias Forall.Files.FileReference, as: DomainFileReference
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

  def from_domain(fr = %DomainFileReference{}) do
    %__MODULE__{
      name: fr.name,
      version: fr.version
    }
  end
end
