defmodule Tutorial.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tutorial.Accounts.{User, Credential}
  alias Tutorial.CMS.{Creator, Flok}

  schema "users" do
    field :avatar, :string
    field :email, :string
    field :joined, :string
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
end
