defmodule Forall.Files.File do
  @moduledoc """
  A File is a code with a name and a version that has already been published. It has been
  typechecked and it's content (code and dependencies) are immutable and thus can be easily cached.
  """
  use TypedEctoSchema
  require Ecto.Query

  @primary_key false
  typed_schema "files" do
    field :name, :string
    field :version, :string

    timestamps()
  end

  def get_query(name, version) do
    Ecto.Query.from(f in __MODULE__, where: f.name == ^name and f.version == ^version)
  end
end
