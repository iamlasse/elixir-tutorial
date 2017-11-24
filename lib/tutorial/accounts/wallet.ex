defmodule Tutorial.Accounts.Wallet do
  @moduledoc """
    Wallet resource
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Tutorial.Accounts.Wallet

  schema "wallets" do
    field :date, :naive_datetime
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(%Wallet{} = wallet, attrs) do
    wallet
    |> cast(attrs, [:type, :date])
    |> validate_required([:type, :date])
  end
end
