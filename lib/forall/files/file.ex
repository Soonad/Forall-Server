defmodule Forall.Files.File do
  @moduledoc """
  A File is a code with a name and a version that has already been published. It has been
  typechecked and it's content (code and dependencies) are immutable and thus can be easily cached.
  """
  use TypedEctoSchema

  @primary_key false
  typed_schema "files" do
    field :name, :string
    field :version, :string
    field :upload_id, :binary_id

    timestamps()
  end
end
