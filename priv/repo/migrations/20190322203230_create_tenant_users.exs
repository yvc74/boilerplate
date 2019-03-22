defmodule Boilerplate.Repo.Migrations.CreateTenantUsers do
  use Ecto.Migration

  def change do
    create table(:tenant_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :tenant_id, references(:tenants, on_delete: :nothing, type: :binary_id), null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:tenant_users, [:id])
    create unique_index(:tenant_users, [:tenant_id, :user_id])
  end
end
