defmodule Tutorial.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tutorial.Accounts.{Credential, User}


  schema "credentials" do
    field :email, :string
    field :password_hash, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
  end
end
