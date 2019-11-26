defmodule Forall.Files.FileReference do
  @moduledoc """
  A file reference is just the id of a file (that is, name and version)
  """

  use TypedEctoSchema

  @primary_key false
  typed_embedded_schema do
    field :namespace, :string
    field :name, :string
    field :version, :string
  end
end
