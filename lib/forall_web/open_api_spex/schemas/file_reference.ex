defmodule ForallWeb.OpenApiSpex.Schemas.FileReference do
  @moduledoc false

  require OpenApiSpex
  alias Forall.Files.FileReference, as: DomainFileReference
  alias ForallWeb.OpenApiSpex.Schemas.FileName
  alias ForallWeb.OpenApiSpex.Schemas.FileNamespace
  alias ForallWeb.OpenApiSpex.Schemas.FileVersion

  OpenApiSpex.schema(%{
    title: "FileReference",
    description: "The id of a file, composed by its namespace, name and version.",
    type: :object,
    properties: %{
      namespace: FileNamespace.schema(),
      name: FileName.schema(),
      version: FileVersion.schema()
    },
    required: [:namespace, :name, :version]
  })

  def from_domain(%DomainFileReference{namespace: namespace, name: name, version: version}) do
    %__MODULE__{namespace: namespace, name: name, version: version}
  end
end
