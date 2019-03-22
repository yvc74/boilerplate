defmodule Boilerplate.AccountsTest do
  use Boilerplate.DataCase

  alias Boilerplate.Accounts
  alias Boilerplate.Accounts.User

  @create_attrs %{email: "fred@example.com", password: "reallyHard2gue$$"}
  @update_attrs %{email: "frederick@example.com"}
  @invalid_attrs %{email: "", password: ""}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Accounts.create_user(attrs)
    user
  end

  describe "read user data" do
    test "list_users/1 returns all users" do
      user = fixture(:user)
      assert Accounts.list_users() == [user]
    end

    test "get returns the user with given id" do
      user = fixture(:user)
      assert Accounts.get_user(user.id) == user
    end

    test "change_user/1 returns a user changeset" do
      user = fixture(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "write user data" do
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@create_attrs)
      assert user.email == "fred@example.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = fixture(:user)
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "frederick@example.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = fixture(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user(user.id)
    end

    test "update password changes the stored hash" do
      %{password_hash: stored_hash} = user = fixture(:user)
      attrs = %{password: "CN8W6kpb"}
      {:ok, %{password_hash: hash}} = Accounts.update_password(user, attrs)
      assert hash != stored_hash
    end

    test "update_password with weak password fails" do
      user = fixture(:user)
      attrs = %{password: "pass"}
      assert {:error, %Ecto.Changeset{}} = Accounts.update_password(user, attrs)
    end
  end

  describe "delete user data" do
    test "delete_user/1 deletes the user" do
      user = fixture(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      refute Accounts.get_user(user.id)
    end
  end

  describe "tenants" do
    alias Boilerplate.Accounts.Tenant

    @valid_attrs %{name: "some name", slug: "some slug"}
    @update_attrs %{name: "some updated name", slug: "some updated slug"}
    @invalid_attrs %{name: nil, slug: nil}

    def tenant_fixture(attrs \\ %{}) do
      {:ok, tenant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_tenant()

      tenant
    end

    test "list_tenants/0 returns all tenants" do
      tenant = tenant_fixture()
      assert Accounts.list_tenants() == [tenant]
    end

    test "get_tenant!/1 returns the tenant with given id" do
      tenant = tenant_fixture()
      assert Accounts.get_tenant!(tenant.id) == tenant
    end

    test "create_tenant/1 with valid data creates a tenant" do
      assert {:ok, %Tenant{} = tenant} = Accounts.create_tenant(@valid_attrs)
      assert tenant.name == "some name"
      assert tenant.slug == "some slug"
    end

    test "create_tenant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_tenant(@invalid_attrs)
    end

    test "update_tenant/2 with valid data updates the tenant" do
      tenant = tenant_fixture()
      assert {:ok, %Tenant{} = tenant} = Accounts.update_tenant(tenant, @update_attrs)
      assert tenant.name == "some updated name"
      assert tenant.slug == "some updated slug"
    end

    test "update_tenant/2 with invalid data returns error changeset" do
      tenant = tenant_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_tenant(tenant, @invalid_attrs)
      assert tenant == Accounts.get_tenant!(tenant.id)
    end

    test "delete_tenant/1 deletes the tenant" do
      tenant = tenant_fixture()
      assert {:ok, %Tenant{}} = Accounts.delete_tenant(tenant)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_tenant!(tenant.id) end
    end

    test "change_tenant/1 returns a tenant changeset" do
      tenant = tenant_fixture()
      assert %Ecto.Changeset{} = Accounts.change_tenant(tenant)
    end
  end

  describe "tenant_users" do
    alias Boilerplate.Accounts.TenantUser

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def tenant_user_fixture(attrs \\ %{}) do
      {:ok, tenant_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_tenant_user()

      tenant_user
    end

    test "list_tenant_users/0 returns all tenant_users" do
      tenant_user = tenant_user_fixture()
      assert Accounts.list_tenant_users() == [tenant_user]
    end

    test "get_tenant_user!/1 returns the tenant_user with given id" do
      tenant_user = tenant_user_fixture()
      assert Accounts.get_tenant_user!(tenant_user.id) == tenant_user
    end

    test "create_tenant_user/1 with valid data creates a tenant_user" do
      assert {:ok, %TenantUser{} = tenant_user} = Accounts.create_tenant_user(@valid_attrs)
    end

    test "create_tenant_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_tenant_user(@invalid_attrs)
    end

    test "update_tenant_user/2 with valid data updates the tenant_user" do
      tenant_user = tenant_user_fixture()
      assert {:ok, %TenantUser{} = tenant_user} = Accounts.update_tenant_user(tenant_user, @update_attrs)
    end

    test "update_tenant_user/2 with invalid data returns error changeset" do
      tenant_user = tenant_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_tenant_user(tenant_user, @invalid_attrs)
      assert tenant_user == Accounts.get_tenant_user!(tenant_user.id)
    end

    test "delete_tenant_user/1 deletes the tenant_user" do
      tenant_user = tenant_user_fixture()
      assert {:ok, %TenantUser{}} = Accounts.delete_tenant_user(tenant_user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_tenant_user!(tenant_user.id) end
    end

    test "change_tenant_user/1 returns a tenant_user changeset" do
      tenant_user = tenant_user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_tenant_user(tenant_user)
    end
  end
end
