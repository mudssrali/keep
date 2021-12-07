defmodule KeepWeb.API.TodoController do
  @doc """
  Provides action handlers for public API
  """
  use KeepWeb, :controller

  alias Keep.Todo

  @doc """
  Get all archived and unarchived lists with items
  """
  def index(conn, _) do
    lists = Todo.all()
    render(conn, "lists.json", lists: lists)
  end

  @doc """
  Get all archived and unarchived lists with items
  """
  def get_lists(conn, _) do
    lists = Todo.all()
    render(conn, "lists.json", lists: lists)
  end

  @doc """
  Get single list with items
  """
  def get_list(conn, params) do
    %{"id" => list_id} = params
    response = case Todo.get_list!(list_id) do
      {:error, error} ->
        failed(error)
      list ->
        succeed(list) 
    end
  
    render(conn, "single_list.json", response: response)
  end

  @doc """
  Create a new todo list
  """
  def create_list(conn, params) do
    attrs = %{
      title: Map.get(params, "title")
    }

    response =
      case Todo.create_list(attrs) do
        {:ok, list} ->
          succeed(list)

        {:error, error} ->
          failed(error)
      end

    render(conn, "single_list.json", response: response)
  end

  @doc """
  Update an existing todo list
  """
  def update_list(conn, params) do
    list_id = Map.get(params, "list_id")

    attrs = %{
      title: Map.get(params, "title")
    }

    response =
      case Todo.update_list(list_id, attrs) do
        {:ok, list} ->
          succeed(list)

        {:error, error} ->
          failed(error)
      end

    render(conn, "single_list.json", response: response)
  end

  @doc """
  Archive or unachive an existing todo list
  """
  def update_list_status(conn, params) do
    id = Map.get(params, "list_id")
    status = Map.get(params, "archived")

    status = if is_boolean(status), do: status, else: String.to_existing_atom(status)

    response =
      case Todo.update_list_status(id, status) do
        {:ok, list} ->
          succeed(list)

        {:error, error} ->
          failed(error)
      end

    render(conn, "single_list.json", response: response)
  end

  @doc """
  Create a new todo list item
  """
  def create_item(conn, params) do
    attrs = %{
      list_id: Map.get(params, "list_id"),
      content: Map.get(params, "content")
    }

    response =
      case Todo.create_item(attrs) do
        {:ok, item} ->
          succeed(item)

        {:error, error} ->
          failed(error)
      end

    render(conn, "single_item.json", response: response)
  end

  @doc """
  Update a new todo list item
  """
  def update_item(conn, params) do
    item_id = Map.get(params, "item_id")

    attrs = %{
      content: Map.get(params, "content")
    }

    response =
      case Todo.update_item(item_id, attrs) do
        {:ok, item} ->
          succeed(item)

        {:error, error} ->
          failed(error)
      end

    render(conn, "single_item.json", response: response)
  end

  @doc """
  Update item status to completed or not completed
  """
  def update_item_status(conn, params) do
    id = Map.get(params, "item_id")
    status = Map.get(params, "completed")

    status = if is_boolean(status), do: status, else: String.to_existing_atom(status)

    response =
      case Todo.update_item_status(id, status) do
        {:ok, item} ->
          succeed(item)

        {:error, error} ->
          failed(error)
      end

    render(conn, "single_item.json", response: response)
  end

  defp succeed(data) do
    %{
      status: "success",
      code: 200,
      data: data,
      error: nil
    }
  end

  defp failed(error) do
    %{
      status: "failed",
      code: 500,
      data: nil,
      error: error
    }
  end
end
