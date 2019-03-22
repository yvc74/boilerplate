defmodule Boilerplate.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Boilerplate.{Accounts.User, Repo, Sessions, Sessions.Session}

  @type changeset_error :: {:error, Ecto.Changeset.t()}

  @doc """
  Returns the list of users.
  """
  @spec list_users() :: [User.t()]
  def list_users, do: Repo.all(User)

  @doc """
  Gets a single user.
  """
  @spec get_user(integer) :: User.t() | nil
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a user based on the params.

  This is used by Phauxth to get user information.
  """
  @spec get_by(map) :: User.t() | nil
  def get_by(%{"session_id" => session_id}) do
    with %Session{user_id: user_id} <- Sessions.get_session(session_id),
         do: get_user(user_id)
  end

  def get_by(%{"email" => email}) do
    Repo.get_by(User, email: email)
  end

  def get_by(%{"user_id" => user_id}), do: Repo.get(User, user_id)

  @doc """
  Creates a user.
  """
  @spec create_user(map) :: {:ok, User.t()} | changeset_error
  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  @spec update_user(User.t(), map) :: {:ok, User.t()} | changeset_error
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.
  """
  @spec delete_user(User.t()) :: {:ok, User.t()} | changeset_error
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  @spec change_user(User.t()) :: Ecto.Changeset.t()
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Confirms a user's email.
  """
  @spec confirm_user(User.t()) :: {:ok, User.t()} | changeset_error
  def confirm_user(%User{} = user) do
    user |> User.confirm_changeset() |> Repo.update()
  end

  @doc """
  Makes a password reset request.
  """
  @spec create_password_reset(map) :: {:ok, User.t()} | nil
  def create_password_reset(attrs) do
    with %User{} = user <- get_by(attrs) do
      user
      |> User.password_reset_changeset(DateTime.utc_now() |> DateTime.truncate(:second))
      |> Repo.update()
    end
  end

  @doc """
  Updates a user's password.
  """
  @spec update_password(User.t(), map) :: {:ok, User.t()} | changeset_error
  def update_password(%User{} = user, attrs) do
    Sessions.delete_user_sessions(user)

    user
    |> User.create_changeset(attrs)
    |> User.password_updated_changeset()
    |> Repo.update()
  end

  alias Boilerplate.Accounts.Tenant

  @doc """
  Returns the list of tenants.

  ## Examples

      iex> list_tenants()
      [%Tenant{}, ...]

  """
  def list_tenants do
    Repo.all(Tenant)
  end

  @doc """
  Gets a single tenant.

  Raises `Ecto.NoResultsError` if the Tenant does not exist.

  ## Examples

      iex> get_tenant!(123)
      %Tenant{}

      iex> get_tenant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tenant!(id), do: Repo.get!(Tenant, id)

  @doc """
  Creates a tenant.

  ## Examples

      iex> create_tenant(%{field: value})
      {:ok, %Tenant{}}

      iex> create_tenant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tenant(attrs \\ %{}) do
    %Tenant{}
    |> Tenant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tenant.

  ## Examples

      iex> update_tenant(tenant, %{field: new_value})
      {:ok, %Tenant{}}

      iex> update_tenant(tenant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tenant(%Tenant{} = tenant, attrs) do
    tenant
    |> Tenant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tenant.

  ## Examples

      iex> delete_tenant(tenant)
      {:ok, %Tenant{}}

      iex> delete_tenant(tenant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tenant(%Tenant{} = tenant) do
    Repo.delete(tenant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tenant changes.

  ## Examples

      iex> change_tenant(tenant)
      %Ecto.Changeset{source: %Tenant{}}

  """
  def change_tenant(%Tenant{} = tenant) do
    Tenant.changeset(tenant, %{})
  end

  alias Boilerplate.Accounts.TenantUser

  @doc """
  Returns the list of tenant_users.

  ## Examples

      iex> list_tenant_users()
      [%TenantUser{}, ...]

  """
  def list_tenant_users do
    Repo.all(TenantUser)
  end

  @doc """
  Gets a single tenant_user.

  Raises `Ecto.NoResultsError` if the Tenant user does not exist.

  ## Examples

      iex> get_tenant_user!(123)
      %TenantUser{}

      iex> get_tenant_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tenant_user!(id), do: Repo.get!(TenantUser, id)

  @doc """
  Creates a tenant_user.

  ## Examples

      iex> create_tenant_user(%{field: value})
      {:ok, %TenantUser{}}

      iex> create_tenant_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tenant_user(attrs \\ %{}) do
    %TenantUser{}
    |> TenantUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tenant_user.

  ## Examples

      iex> update_tenant_user(tenant_user, %{field: new_value})
      {:ok, %TenantUser{}}

      iex> update_tenant_user(tenant_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tenant_user(%TenantUser{} = tenant_user, attrs) do
    tenant_user
    |> TenantUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TenantUser.

  ## Examples

      iex> delete_tenant_user(tenant_user)
      {:ok, %TenantUser{}}

      iex> delete_tenant_user(tenant_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tenant_user(%TenantUser{} = tenant_user) do
    Repo.delete(tenant_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tenant_user changes.

  ## Examples

      iex> change_tenant_user(tenant_user)
      %Ecto.Changeset{source: %TenantUser{}}

  """
  def change_tenant_user(%TenantUser{} = tenant_user) do
    TenantUser.changeset(tenant_user, %{})
  end
end
