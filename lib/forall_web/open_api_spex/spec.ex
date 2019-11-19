defmodule ForallWeb.OpenApiSpex.Spec do
  @moduledoc "The API Spec root"

  alias ForallWeb.{Endpoint, Router}
  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Forall",
        version: "1.0"
      },
      # populate the paths from a phoenix router
      paths: Paths.from_router(Router)
    }
    # discover request/response schemas from path specs
    |> OpenApiSpex.resolve_schema_modules()
  end
end
