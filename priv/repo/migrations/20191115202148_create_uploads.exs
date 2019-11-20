defmodule Forall.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :name, :string
      add :version, :string
      add :error, :string

      timestamps()
    end
  end
end
