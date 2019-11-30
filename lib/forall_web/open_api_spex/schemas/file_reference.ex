defmodule ForallWeb.OpenApiSpex.Schemas.FileReference do
  @moduledoc false

  require OpenApiSpex
  alias Forall.Files.FileReference, as: DomainFileReference
  alias ForallWeb.OpenApiSpex.Schemas.FileName
  alias ForallWeb.OpenApiSpex.Schemas.FileVersion

  OpenApiSpex.schema(%{
    title: "FileReference",
    description: "The id of a file, composed by its name and version.",
    type: :object,
    properties: %{
      name: FileName.schema(),
      version: FileVersion.schema()
    },
    required: [:name, :version]
  })

  def from_domain(%DomainFileReference{name: name, version: version}) do
    %__MODULE__{name: name, version: version}
  end
end
