defmodule Boilerplate.Accounts.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  alias Boilerplate.Accounts.TenantUser

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenants" do
    field :name, :string, default: ""
    field :slug, :string, default: ""

    has_many :tenant_users, TenantUser

    timestamps()
  end

  @doc false
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end
end
