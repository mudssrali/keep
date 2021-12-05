defmodule Keep.Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Keep.Todo.Item
  alias Keep.Todo.List

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "todo_items" do
    field :content, :string
    field :completed, :boolean, default: false
    belongs_to :list, List, foreign_key: :list_id, type: :binary_id, references: :id

    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:content, :completed, :list_id])
    |> validate_required([:content, :list_id])
  end
end
