defmodule ForallWeb.FileController do
  use ForallWeb.Controller

  alias Forall.Files.FileReference, as: DomainFileReference

  alias ForallWeb.OpenApiSpex.Schemas.File
  alias ForallWeb.OpenApiSpex.Schemas.FileName
  alias ForallWeb.OpenApiSpex.Schemas.FileNamespace
  alias ForallWeb.OpenApiSpex.Schemas.FileReference
  alias ForallWeb.OpenApiSpex.Schemas.FileVersion
  alias ForallWeb.OpenApiSpex.Schemas.PublishFileRequest

  plug OpenApiSpex.Plug.CastAndValidate

  doc(:show,
    tags: ["files"],
    summary: "Gets a file with it's metadata",
    operation_id: "get-file",
    parameters: [
      parameter(:namespace, :path, FileNamespace.schema(), "File Namespace"),
      parameter(:name, :path, FileName.schema(), "File Name"),
      parameter(:version, :path, FileVersion.schema(), "File Version")
    ],
    responses: %{
      200 => response("File has been found", File)
    }
  )

  def show(conn, %{namespace: namespace, name: name, version: version}) do
    file_reference = %DomainFileReference{namespace: namespace, name: name, version: version}

    case Forall.Files.get_file(file_reference) do
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
      202 => response("File publication request has been received", FileReference)
    }
  )

  def create(conn, _) do
    case casted_body(conn) do
      %{namespace: namespace = "public", name: name, code: code} ->
        {:ok, file_reference} = Forall.Files.publish_file(namespace, name, code)

        conn
        |> put_status(:accepted)
        |> render("create.json", file_reference: file_reference)

      _ ->
        conn
        |> put_status(:forbidden)
        |> json(%{errors: %{detail: "Only public namespaced allowed at this time."}})
    end
  end
end
