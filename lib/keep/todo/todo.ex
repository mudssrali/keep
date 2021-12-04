defmodule Keep.Todo do
  @moduledoc """
  Provides handles to create, update, archive/unarchive and mark complete/incomplete list and list items.
  """
  import Ecto.Query

  alias Keep.Repo
  alias Keep.Todo.List
  alias Keep.Todo.Item

  @doc """
  returns all todo lists with items
  """
  def all do
    Repo.all(List)
    |> Repo.preload(:items)
  end

  @doc """
  returns a todo list with items
  """
  def get_list!(id) do
    Repo.get!(List, id)
    |> Repo.preload(:items)
  end

  @doc """
  returns an todo list item
  """
  def get_item!(id)do
    Repo.get!(Item, id)
  end

  @doc """
  returns an empty todo list struct
  """
  def new_list do
    List.changeset(%List{}, %{})
  end

  @doc """
  creates a new todo list
  """
  def create_list(attrs) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  updates a todo list
  """
  def update_list(id, attrs) do
    list = get_list!(id)

    if list.archived do
      {:error, "archived list cannot be updated."}
    end

    list = Ecto.Changeset.change(list, archived: Map.get(attrs, :title))
    Repo.update(list)
  end

  @doc """
  archives an existing list
  """
  @spec archive_list(String.t()) :: %List{}
  def archive_list(id) do
    list = get_list!(id)
    list = Ecto.Changeset.change(list, archived: true)
    Repo.update(list)
  end

  @doc """
  creates a todo list item
  """
  def create_item(attrs) do
    list = get_list!(attrs.list_id)

    if list.archived do
      {:error, "item cannot be created in archived list."}
    else
      %Item{}
      |> Item.changeset(attrs)
      |> Repo.insert()
    end
  end

  @doc """
  updates a todo list item
  """
  def update_item(id, attrs) do
    item = get_item!(id)
    list = get_list!(item.list_id)

    if list.archived do
      {:error, "item cannot be updated in archived list."}
    else
      item = Ecto.Changeset.change(item, content: attrs.content)
      Repo.update(item)
    end
  end

  @doc """
  marks list item as completed
  """
  @spec mark_item_completed(String.t()) :: %Item{}
  def mark_item_completed(id) do
    item = get_item!(id)
    list = get_list!(item.list_id)

    if list.archived do
      {:error, "item cannot be marked as completed in archived list."}
    else
      item = Ecto.Changeset.change(item, completed: true)
      Repo.update(item)
    end
  end

  @doc """
  creates a todo list with items
  """
  @spec create_list_with_items(%{}, [String.t()]) :: %List{}
  def create_list_with_items(list_attrs, items) do
    Repo.transaction(fn ->
      with {:ok, list} <- create_list(list_attrs),
           {:ok, _} <- create_items(items, list) do
        list |> Repo.preload(:items)
      else
        _ -> Repo.rollback("Failed to create list")
      end
    end)
  end

  @doc """
  creates items for a todo list
  """
  @spec create_items([String.t()], %List{}) :: {}
  def create_items(items, list) do
    results =
      items
      |> Enum.map(fn content ->
        create_item(%{content: content, list_id: list.id})
      end)

    if Enum.any?(results, fn {status, _} -> status == :error end) do
      {:error, "Failed to create an item"}
    else
      {:ok, results}
    end
  end

  @doc """
  archives all unarchived lists that have not been updated in last 24 hours
  """
  def archive_lists do
    query =
      from l in List,
        where:
          l.archived == false and
            (l.inserted_at == l.updated_at or
               l.updated_at < datetime_add(^NaiveDateTime.utc_now(), -1, "hour"))

    Repo.update_all(query, set: [archived: true, updated_at: NaiveDateTime.utc_now()])
  end
end
