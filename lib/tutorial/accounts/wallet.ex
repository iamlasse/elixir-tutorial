defmodule Tutorial.Accounts.Wallet do
  @moduledoc """
    Wallet resource
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Tutorial.Accounts.Wallet
  alias Tutorial.Accounts.User

  schema "wallets" do
    field :date, :naive_datetime
    field :type, :string

    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(%Wallet{} = wallet, attrs) do
    wallet
    |> cast(attrs, [:type, :date])
    |> validate_required([:type, :date])
  end
end
