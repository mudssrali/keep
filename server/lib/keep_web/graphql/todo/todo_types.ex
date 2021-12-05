defmodule KeepWeb.GraphQL.TodoTypes do
  @moduledoc """
  Provides graphql types for Todo
  """

  use Absinthe.Schema.Notation

  alias KeepWeb.GraphQL.TodoResolvers

  object :todo_queries do
    @desc "get all todos"
    field :get_todos, :todos_data do
      resolve(&TodoResolvers.get_todos/3)
    end

    @desc "get todo list with items"
    field :get_todo, :todo_list do
      arg(:list_id, non_null(:string))
      resolve(&TodoResolvers.get_todo_list/3)
    end
  end

  object :todo_mutations do
    @desc "create a new todo list"
    field :create_todo_list, :todo_list do
      arg(:todo_list, non_null(:create_todo_list))
      resolve(&TodoResolvers.create_todo_list/3)
    end

    @desc "update an existing todo list"
    field :update_todo_list, :todo_list do
      arg(:todo_list, non_null(:update_todo_list))
      resolve(&TodoResolvers.update_todo_list/3)
    end

    @desc "update status of a todo list"
    field :update_todo_list_status, :todo_list do
      arg(:todo_list, non_null(:update_todo_list_status))
      resolve(&TodoResolvers.update_todo_list_status/3)
    end

    @desc "create a new todo item"
    field :create_todo_item, :todo_item do
      arg(:todo_item, non_null(:create_todo_item))
      resolve(&TodoResolvers.create_todo_item/3)
    end

    @desc "update an existing todo item"
    field :update_todo_item, :todo_item do
      arg(:todo_item, non_null(:update_todo_item))
      resolve(&TodoResolvers.update_todo_item/3)
    end

    @desc "update status of a todo item"
    field :update_todo_item_status, :todo_item do
      arg(:todo_item, non_null(:update_todo_item_status))
      resolve(&TodoResolvers.update_todo_item_status/3)
    end
  end

 input_object :create_todo_list do
    field(:title, :string)
  end

 input_object :update_todo_list do
    field(:id, :string)
    field(:title, :string)
  end

 input_object :update_todo_list_status do
    field(:id, :string)
    field(:archived, :string)
  end

 input_object :create_todo_item do
    field(:list_id, :string)
    field(:content, :string)
  end

 input_object :update_todo_item do
    field(:id, :string)
    field(:content, :string)
  end

 input_object :update_todo_item_status do
    field(:id, :string)
    field(:completed, :string)
  end

  object :todo_item do
    field(:id, :string)
    field(:content, :string)
    field(:completed, :boolean)
    field(:inserted_at, :date)
    field(:updated_at, :date)
  end

  object :todo_list do
    field(:id, :string)
    field(:title, :string)
    field(:archived, :boolean)
    field(:inserted_at, :date)
    field(:updated_at, :date)
    field(:items, list_of(:todo_item))
  end

  object :todos_data do
    field(:todos, list_of(:todo_list))
  end
end
