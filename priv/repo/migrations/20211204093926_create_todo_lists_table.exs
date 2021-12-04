defmodule Keep.Repo.Migrations.CreateTodoListsTable do
  use Ecto.Migration

  @doc false
  def change do
    create table(:todo_lists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :archived, :boolean, null: false, default: false

      timestamps()
    end
  end
end
