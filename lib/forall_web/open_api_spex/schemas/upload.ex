defmodule ForallWeb.OpenApiSpex.Schemas.Upload do
  @moduledoc false

  require OpenApiSpex
  alias ForallWeb.OpenApiSpex.Schemas

  OpenApiSpex.schema(%{
    title: "Upload",
    description: "A successfully uploaded and published upload",
    type: :object,
    properties: %{
      id: Schemas.UploadId.schema(),
      name: Schemas.FileName.schema(),
      version: Schemas.FileVersion.schema(),
      error: Schemas.UploadError.schema()
    },
    required: [:name]
  })

  @spec from_domain(Forall.Uploads.Upload.t()) :: ForallWeb.OpenApiSpex.Schemas.Upload.t()
  def from_domain(upload = %Forall.Uploads.Upload{}) do
    %__MODULE__{
      id: upload.id,
      name: upload.name,
      version: upload.version,
      error: upload.error
    }
  end
end
