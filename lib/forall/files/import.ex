defmodule Forall.Files.Import do
  @moduledoc """
  A directed relation between two files, where one imports the other.
  Since imports need to be fetched before uploading a new file, this is guaranteed to not be
  circular.
  """

  use TypedEctoSchema
  require Ecto.Query
  alias Forall.Files.FileReference

  @primary_key false
  typed_schema "imports" do
    field :importer_name, :string
    field :importer_version, :string
    field :imported_name, :string
    field :imported_version, :string
  end

  def imported_reference(%__MODULE__{} = i) do
    %FileReference{
      name: i.imported_name,
      version: i.imported_version
    }
  end

  def importer_reference(%__MODULE__{} = i) do
    %FileReference{
      name: i.importer_name,
      version: i.importer_version
    }
  end

  def by_imported(%FileReference{name: name, version: version}) do
    Ecto.Query.from(f in __MODULE__,
      where: f.imported_name == ^name and f.imported_version == ^version
    )
  end

  def by_importer(%FileReference{name: name, version: version}) do
    Ecto.Query.from(f in __MODULE__,
      where: f.importer_name == ^name and f.importer_version == ^version
    )
  end
end
