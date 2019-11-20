defmodule ForallWeb.OpenApiSpex.Schemas.UploadError do
  @moduledoc false

  @behaviour OpenApiSpex.Schema

  def schema do
    %OpenApiSpex.Schema{
      title: "UploadError",
      type: :string,
      description:
        Enum.join(
          [
            "Possible upload errors.",
            "hash_collision means there is already a file with a similar content and name.",
            "typecheck means either a type annotation is missing or is incorrect."
          ],
          "\n"
        ),
      enum: ["hash_collision", "typecheck"]
    }
  end
end
