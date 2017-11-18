defmodule Tutorial.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :type, :string
      add :date, :naive_datetime

      timestamps()
    end

  end
end
