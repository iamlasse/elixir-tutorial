defmodule Tutorial.Repo.Migrations.CreateFloksPlayers do
  use Ecto.Migration

  def change do
    create table(:floks_players) do
      add :user_id, references(:users)
      add :flok_id, references(:floks)

      timestamps()
    end
     create unique_index(:floks_players, [:flok_id, :user_id])
  end
end
