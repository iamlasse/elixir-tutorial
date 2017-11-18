defmodule Tutorial.CMS.Flok do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tutorial.CMS.{Flok, Creator}
  alias Tutorial.Accounts.User


  schema "floks" do
    field :description, :string
    field :published, :string
    field :sport, :string
    field :title, :string
    many_to_many :players, User, join_through: "floks_players"
    belongs_to :creator, Creator

    timestamps()
  end

  @doc false
  def changeset(%Flok{} = flok, attrs) do
    flok
    |> cast(attrs, [:title, :description, :published, :sport])
    |> validate_required([:title, :description, :published, :sport])
    |> unique_constraint(:title)
  end
end
