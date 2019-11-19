defmodule ForallWeb.Router do
  use Phoenix.Router
  import Phoenix.Controller

  pipeline :api do
    plug OpenApiSpex.Plug.PutApiSpec, module: ForallWeb.OpenApiSpex.Spec
    plug :accepts, ["json"]
  end

  scope "/api", ForallWeb do
    pipe_through :api

    resources "/uploads", UploadController, only: [:create, :show]
    get "/files/:name/:version", FileController, :show
  end

  scope "/openapi" do
    pipe_through :api

    get "/", OpenApiSpex.Plug.RenderSpec, []
  end
end
