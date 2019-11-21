defmodule ForallWeb.Router do
  use Phoenix.Router
  import Phoenix.Controller

  pipeline :api do
    plug OpenApiSpex.Plug.PutApiSpec, module: ForallWeb.OpenApiSpex.Spec
    plug :accepts, ["json"]
  end

  scope "/api", ForallWeb do
    pipe_through :api

    get "/files/:name/:version", FileController, :show
    post "/files/:name", FileController, :create
  end

  scope "/openapi" do
    pipe_through :api

    get "/", OpenApiSpex.Plug.RenderSpec, []
  end
end
