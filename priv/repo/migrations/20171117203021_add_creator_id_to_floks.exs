defmodule Tutorial.Repo.Migrations.AddCreatorIdToFloks do
  use Ecto.Migration

  def change do
    alter table(:floks) do
      add :creator_id, references(:creators, on_delete: :delete_all), null: false
    end
    create index(:floks, [:creator_id])
  end
end
