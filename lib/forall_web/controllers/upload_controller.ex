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
      202 =>
        response("Upload request was created.", nil,
          headers: %{
            "Location" => %Schema{
              type: "string",
              example: "/uploads/#{Ecto.UUID.generate()}"
            }
          }
        )
    }
  )

  @spec create(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def create(conn, _) do
    %{name: name, code: code} = casted_body(conn)
    id = Forall.Uploads.create_upload(name, code)

    conn
    |> put_resp_header("Location", "/uploads/#{id}")
    |> send_resp(202, "")
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
      200 => response("Upload was found and it has successfully been processed", Upload)
    }
  )

  def show(conn, %{id: id}) do
    case Forall.Uploads.get_finished_upload(id) do
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
