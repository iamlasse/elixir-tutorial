defmodule Tutorial.Repo.Migrations.CreateFloks do
  use Ecto.Migration

  def change do
    create table(:floks) do
      add :title, :string
      add :description, :text
      add :published, :string
      add :sport, :string
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:floks, [:title])
  end
end
