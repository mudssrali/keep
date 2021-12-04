defmodule KeepWeb.API.TodoView do
  use KeepWeb, :view
  @moduledoc false
  alias KeepWeb.API.TodoView

  @doc false
  def render("lists.json", %{lists: lists}) do
    %{
      status: "success",
      code: 200,
      data: render_many(lists, TodoView, "list.json", as: :list)
    }
  end

  @doc false
  def render("single_list.json", %{response: response}) do
    %{
      status: response.status,
      code: response.code,
      data: render_one(response.data, TodoView, "list.json", as: :list),
      error: response.error
    }
  end

  @doc false
  def render("single_item.json", %{response: response}) do
    %{
      status: response.status,
      code: response.code,
      data: render_one(response.data, TodoView, "item.json", as: :item),
      error: response.error
    }
  end

  @doc false
  def render("list.json", %{list: list}) do
    %{
      id: list.id,
      archived: list.archived,
      inserted_at: list.inserted_at,
      updated_at: list.updated_at,
      items: render_many(list.items, TodoView, "item.json", as: :item)
    }
  end

  @doc false
  def render("item.json", %{item: item}) do
    %{
      id: item.id,
      list_id: item.list_id,
      completed: item.completed,
      content: item.content,
      inserted_at: item.inserted_at,
      updated_at: item.updated_at
    }
  end

end