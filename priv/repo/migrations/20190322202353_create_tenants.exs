defmodule Boilerplate.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS citext")
  
    create table(:tenants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :slug, :citext, null: false

      timestamps()
    end

    create index(:tenants, [:id])
    create unique_index(:tenants, ["lower(slug)"])

  end

  def down do
    drop table(:tenants)
  end
end
