defmodule ForallWeb.UploadController do
  use ForallWeb.Controller
  alias OpenApiSpex.Schema
  alias ForallWeb.OpenApiSpex.Schemas.{CreateUploadRequest, Upload}

  plug OpenApiSpex.Plug.CastAndValidate

  doc(:create,
    tags: ["uploads"],
    summary: "Request the upload of a new file",
    operation_id: "create-upload",
    request_body: request_body("The body for creating an upload", CreateUploadRequest),
    responses: %{
      200 => response("Upload request was created", Upload)
    }
  )

  @spec create(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def create(conn, _) do
    %{name: name, code: code} = casted_body(conn)
    {:ok, upload} = Forall.Uploads.create_upload(name, code)

    render(conn, "show.json", upload: upload)
  end

  doc(:show,
    tags: ["uploads"],
    summary: "Gets a successfully uploaded and published upload",
    operation_id: "get-upload",
    parameters: [
      parameter(
        :id,
        :path,
        %Schema{
          type: :string,
          format: "uuid"
        },
        "Upload Id"
      )
    ],
    responses: %{
      200 => response("Upload was found", Upload)
    }
  )

  def show(conn, %{id: id}) do
    case Forall.Uploads.get_upload(id) do
      {:ok, upload} ->
        render(conn, "show.json", upload: upload)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(ForallWeb.ErrorView)
        |> render("404.json")
    end
  end
end
