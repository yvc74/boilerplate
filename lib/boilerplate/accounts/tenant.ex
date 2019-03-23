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
    |> validate_format(:slug, slug_format())
  end

  defp slug_format do
    ~r/^(?>[A-Za-z][A-Za-z0-9-\.]*[A-Za-z0-9])$/  
  end
end
