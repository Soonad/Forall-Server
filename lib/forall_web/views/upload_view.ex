defmodule ForallWeb.UploadView do
  use ForallWeb.View
  alias ForallWeb.OpenApiSpex.Schemas.Upload

  def render("show.json", %{upload: upload}) do
    Upload.from_domain(upload)
  end
end
