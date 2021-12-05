defmodule KeepWeb.GraphQL.TodoResolvers do
  use KeepWeb.GraphQL.Errors

  alias KeepWeb.GraphQL.EctoHelpers
  alias Keep.Todo

  def get_todos(_parent, _args, _context) do
    todos = Todo.all()
    {:ok, %{todos: todos}}
  end

  def get_todo_list(_parent, %{list_id: id} = args, _context) do
    {:ok, Todo.get_list!(id)}
  end

  def create_todo_list(_parent, %{todo_list: list} = args, _context) do
    Todo.create_list(list)
  end

  def update_todo_list(_parent, args, _context) do
    %{
      todo_list: %{
        id: id,
        title: title
      }
    } = args

    Todo.update_list(id, %{title: title})
  end

  def update_todo_list_status(_parent, args, _context) do
    %{
      todo_list: %{
        id: id,
        archived: archived
      }
    } = args

    list = Todo.update_list_status(id, archived)
    {:ok, list}
  end

  def create_todo_item(_parent, %{todo_item: item} = args, _context) do
    case Todo.create_item(item) do
      {:ok, list} ->
        {:ok, list}
      {:error, error} ->
        {:error, error}
    end
  end

  def update_todo_item(_parent, args, _context) do
   %{
     todo_item:  %{
      id: id,
      content: content
    }
   } = args

    case Todo.update_item(id, %{content: content}) do
      {:ok, item} ->
        {:ok, item}
      {:error, error} ->
        {:error, error}
    end
  end

  def update_todo_item_status(_parent, args, _context) do
    %{
      todo_item: %{
        id: id,
        completed: completed
      }
    } = args

    case Todo.update_item_status(id, completed) do
      {:ok, item} ->
        {:ok, item}
      {:error, error} ->
        {:error, error}
    end
  end
end
