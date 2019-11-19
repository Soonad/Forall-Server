defmodule ForallWeb.OpenApiSpex.Schemas.Upload do
  @moduledoc false

  require OpenApiSpex
  alias ForallWeb.OpenApiSpex.Schemas.{FileName, FileVersion}

  OpenApiSpex.schema(%{
    title: "Upload",
    description: "A successfully uploaded and published upload",
    type: :object,
    properties: %{
      name: FileName.schema(),
      version: FileVersion.schema()
    },
    required: [:name, :version]
  })

  @spec from_domain(Forall.Uploads.Upload.t()) :: ForallWeb.OpenApiSpex.Schemas.Upload.t()
  def from_domain(upload = %Forall.Uploads.Upload{}) do
    %__MODULE__{
      name: upload.name,
      version: upload.version
    }
  end
end
