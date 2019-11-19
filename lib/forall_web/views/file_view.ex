defmodule ForallWeb.FileView do
  use ForallWeb.View
  alias ForallWeb.OpenApiSpex.Schemas.File

  def render("show.json", %{file: file}) do
    File.from_domain(file)
  end
end
