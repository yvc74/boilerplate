defmodule Boilerplate.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password_hash, :string
      add :confirmed_at, :utc_datetime
      add :reset_sent_at, :utc_datetime

      timestamps()
    end

    create index(:users, [:id])
    create unique_index(:users, [:email])
  end
end
