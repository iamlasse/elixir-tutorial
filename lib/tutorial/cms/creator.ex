defmodule Tutorial.CMS.Creator do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tutorial.CMS.{Creator, Flok}
  alias Tutorial.Accounts.User


  schema "creators" do
    field :bio, :string
    field :favorite_sport, :string
    field :role, :string

    belongs_to :user, User
    has_many(:floks, Flok)
    timestamps()
  end

  @doc false
  def changeset(%Creator{} = creator, attrs) do
    creator
    |> cast(attrs, [:bio, :role, :favorite_sport])
    |> validate_required([:bio, :role, :favorite_sport])
    # |> unique_constraint(:user_id)
  end
end
