defmodule ForallWeb.OpenApiSpex.Schemas.UploadId do
  @moduledoc false

  @behaviour OpenApiSpex.Schema

  def schema do
    %OpenApiSpex.Schema{
      title: "UploadId",
      type: :string,
      format: :uuid,
      description: "The id of the upload to be used to check it's progress"
    }
  end
end
