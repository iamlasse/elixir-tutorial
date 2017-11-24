defmodule Tutorial.Accounts.User do
  @moduledoc """
    User resource
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Tutorial.Accounts.{User, Credential}
  alias Tutorial.CMS.{Creator, Flok}
  alias Comeonin.Bcrypt

  schema "users" do
    field :avatar, :string
    field :email, :string
    field :joined, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string
    many_to_many :floks, Flok, join_through: "floks_players"
    has_one :creator, Creator
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password_hash, :avatar, :joined])
    # |> unique_constraint(:email)
    |> validate_required([:email, :username])
    |> validate_length(:username, min: 8)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:username)
    # |> unique_constraint(:username, name: :users_email_username_index)
    # |> unique_constraint(:username)
  end

  def register_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:email, :username, :password])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password()
    |> unique_constraint(:email)
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
    hashed_password =
      changeset
      |> get_field(:password)
      |> Bcrypt.hashpwsalt()

    changeset
    |> put_change(:password_hash, hashed_password)
  end
end
