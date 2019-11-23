defmodule ForallWeb.FileController do
  use ForallWeb.Controller

  alias ForallWeb.OpenApiSpex.Schemas.File
  alias ForallWeb.OpenApiSpex.Schemas.FileName
  alias ForallWeb.OpenApiSpex.Schemas.FileVersion
  alias ForallWeb.OpenApiSpex.Schemas.PublishFileRequest
  alias ForallWeb.OpenApiSpex.Schemas.PublishFileResponse

  plug OpenApiSpex.Plug.CastAndValidate

  doc(:show,
    tags: ["files"],
    summary: "Gets a file with it's metadata",
    operation_id: "get-file",
    parameters: [
      parameter(:name, :path, FileName.schema(), "File Name"),
      parameter(:version, :path, FileVersion.schema(), "File Version")
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

  doc(:create,
    tags: ["files"],
    summary: "Requests a file publication",
    operation_id: "publish-file",
    request_body: request_body("The body for requesting a file publication", PublishFileRequest),
    responses: %{
      202 => response("File publication request has been received", PublishFileResponse)
    }
  )

  def create(conn, _) do
    %{name: name, code: code} = casted_body(conn)
    {:ok, version} = Forall.Files.publish_file(name, code)

    conn
    |> put_status(:accepted)
    |> render("create.json", name: name, version: version)
  end
end
