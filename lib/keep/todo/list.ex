defmodule Keep.Todo.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias Keep.Todo.List
  alias Keep.Todo.Item

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todo_lists" do
    field :title, :string
    field :archived, :boolean, default: false
    has_many :items, Item

    timestamps()
  end

  @doc false
  def changeset(%List{} = list, attrs) do
    list
    |> cast(attrs, [:title, :archived])
    |> validate_required([:title])
  end
end
