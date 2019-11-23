defmodule Forall.Files.Import do
  @moduledoc """
  A directed relation between two files, where one imports the other.
  Since imports need to be fetched before uploading a new file, this is guaranteed to not be
  circular.
  """

  use TypedEctoSchema
  require Ecto.Query

  @primary_key false
  typed_schema "imports" do
    field :importer_name, :string
    field :importer_version, :string
    field :imported_name, :string
    field :imported_version, :string
  end

  def get_imported_by(imported_name, imported_version) do
    Ecto.Query.from(f in __MODULE__,
      where: f.imported_name == ^imported_name and f.imported_version == ^imported_version
    )
  end

  def get_imports(importer_name, importer_version) do
    Ecto.Query.from(f in __MODULE__,
      where: f.importer_name == ^importer_name and f.importer_version == ^importer_version
    )
  end
end
