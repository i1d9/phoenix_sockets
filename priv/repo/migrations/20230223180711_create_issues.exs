defmodule Todo.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :name, :string
      add :completed, :boolean, default: false, null: false

      timestamps()
    end
  end
end
