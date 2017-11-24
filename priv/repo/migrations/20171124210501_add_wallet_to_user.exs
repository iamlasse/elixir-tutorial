defmodule Tutorial.Repo.Migrations.AddWalletToUser do
  use Ecto.Migration

  def change do
    alter table(:wallets) do
      add :user_id,  references(:users)
    end
  end
end
