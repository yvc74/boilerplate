defmodule Boilerplate.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :expires_at, :utc_datetime

      timestamps()
    end

    create index(:sessions, [:id, :user_id])    
  end
end
