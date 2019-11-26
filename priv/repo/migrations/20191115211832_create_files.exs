defmodule Forall.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :namespace, :string, primary_key: true
      add :name, :string, primary_key: true
      add :version, :string, primary_key: true
      add :deep_imports, :map

      timestamps()
    end
  end
end
