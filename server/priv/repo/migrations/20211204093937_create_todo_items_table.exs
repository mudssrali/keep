defmodule Keep.Repo.Migrations.CreateTodoItemsTable do
  use Ecto.Migration

  @doc false
  def change do
    create table(:todo_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string, null: false
      add :completed, :boolean, null: false, default: false
      add :list_id, references(:todo_lists, column: :id, type: :binary_id)

      timestamps()
    end
  end
end
