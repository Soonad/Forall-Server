defmodule ForallWeb.FileController do
  use ForallWeb.Controller

  alias ForallWeb.OpenApiSpex.Schemas.File
  alias OpenApiSpex.Schema

  plug OpenApiSpex.Plug.CastAndValidate

  doc(:show,
    tags: ["files"],
    summary: "Gets a file with it's metadata",
    operation_id: "get-file",
    parameters: [
      parameter(:name, :path, %Schema{type: :string}, "File Name"),
      parameter(:version, :path, %Schema{type: :string}, "File Version")
    ],
    responses: %{
      200 => response("File has been found", File)
    }
  )

  def show(conn, %{name: name, version: version}) do
    case Forall.Files.get_file(name, version) do
      {:ok, file} ->
        render(conn, "show.json", file: file)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(ForallWeb.ErrorView)
        |> render("404.json")
    end
  end
end
