defmodule Forall.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :name, :string, primary_key: true
      add :version, :string, primary_key: true
      add :upload_id, references(:uploads, on_delete: :nothing)

      timestamps()
    end

    create index(:files, [:upload_id])
  end
end
