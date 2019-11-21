defmodule ForallWeb.FileView do
  use ForallWeb.View
  alias ForallWeb.OpenApiSpex.Schemas.File
  alias ForallWeb.OpenApiSpex.Schemas.PublishFileResponse

  def render("show.json", %{file: file}) do
    File.from_domain(file)
  end

  def render("create.json", %{name: name, version: version}) do
    %PublishFileResponse{
      name: name,
      version: version
    }
  end
end
