defmodule Tutorial.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :password_hash, :string
      add :avatar, :string
      add :joined, :string

      timestamps()
    end
    create unique_index(:users, [:username])
  end
end
