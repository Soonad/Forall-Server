defmodule Forall.Files.File do
  @moduledoc """
  A File is a code with a name and a version that has already been published. It has been
  typechecked and it's content (code and imports) are immutable and thus can be easily cached.
  """
  use TypedEctoSchema
  require Ecto.Query
  alias Forall.Files.FileReference

  @primary_key false
  typed_schema "files" do
    field :name, :string
    field :version, :string

    embeds_many :deep_imports, FileReference
    field(:imported_by, {:array, :any}, virtual: true) :: [FileReference.t()] | nil

    timestamps()
  end

  def get_query(%FileReference{name: name, version: version}) do
    Ecto.Query.from(f in __MODULE__,
      where: f.name == ^name and f.version == ^version
    )
  end

  def reference(%__MODULE__{name: name, version: version}) do
    %FileReference{name: name, version: version}
  end
end
