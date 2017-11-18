defmodule Tutorial.Repo.Migrations.CreateCreators do
  use Ecto.Migration

  def change do
    create table(:creators) do
      add :bio, :text
      add :role, :string
      add :favorite_sport, :string, default: "Soccer"
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:creators, [:user_id])
  end
end
