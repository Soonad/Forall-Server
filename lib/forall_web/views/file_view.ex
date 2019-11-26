defmodule ForallWeb.FileView do
  use ForallWeb.View
  alias ForallWeb.OpenApiSpex.Schemas.File
  alias ForallWeb.OpenApiSpex.Schemas.FileReference

  def render("show.json", %{file: file}) do
    File.from_domain(file)
  end

  def render("create.json", %{file_reference: file_reference}) do
    FileReference.from_domain(file_reference)
  end
end
