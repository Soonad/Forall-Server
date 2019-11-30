defmodule Forall.Repo.Migrations.CreateImports do
  use Ecto.Migration

  def change do
    create table(:imports, primary_key: false) do
      add :importer_name, :string, primary_key: true
      add :importer_version, :string, primary_key: true
      add :imported_name, :string, primary_key: true
      add :imported_version, :string, primary_key: true
    end
  end
end
