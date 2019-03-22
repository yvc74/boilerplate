defmodule Boilerplate.Accounts.TenantUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias Boilerplate.Accounts.{Tenant, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenant_users" do
    belongs_to :tenant, Tenant
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(tenant_user, attrs) do
    tenant_user
    |> cast(attrs, [:tenant_id, :user_id])
    |> validate_required([:tenant_id, :user_id])
  end
end
