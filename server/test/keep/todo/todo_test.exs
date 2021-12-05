defmodule Keep.TodoTest do
  use Keep.DataCase

  alias Keep.Repo
  alias Keep.Todo

  describe "todo" do
    @valid_attrs %{title: "Programming Languages"}

    # Fixtures: In the case of an Ecto application, are just helper functions
    # that create rows in our database that we can use to verify functionality
    def list_fixture(attrs \\ %{}) do
      with create_attrs <- Enum.into(attrs, @valid_attrs),
           {:ok, list} <- Todo.create_list(create_attrs),
           list <- Repo.preload(list, :items) do
        list
      end
    end

    test "all/0 returns all todo list with items" do
      list = list_fixture()
      assert Todo.all() == [list]
    end

    test "new_list/0 returns a new blank changeset" do
      changeset = Todo.new_list()

      # Note: __struct__ is a special property built into Elixir structs that tell you which module they map to,
      #  so since we're just verifying that it creates a new changeset
      assert changeset.__struct__ == Ecto.Changeset
    end

    test "create_list/1 returns a new new" do
      {:ok, list} = Todo.create_list(@valid_attrs)
      assert Enum.any?(Todo.all(), fn l -> l.id == list.id end)
    end

    test "create_list_with_items/2 returns a new list with items" do
      title = "Citrus Fruit"
      items = ["Orange", "Grape Fruit", "Lemon"]
      {:ok, list} = Todo.create_list_with_items(%{title: title}, items)
      assert list.title == title
      assert Enum.count(list.items) == 3
    end

    test "create_list_with_items/2 does not create the list or items with bad data" do
      title = "Bad List"
      items = ["Item 1", nil, "Item 2"]
      {status, _} = Todo.create_list_with_items(%{title: title}, items)
      assert status == :error
      assert !Enum.any?(Todo.all(), fn l -> l.title == "Bad List" end)
    end


    test "update_list_status/1 archives an existing list" do
      {:ok, list} = Todo.create_list(@valid_attrs)
      {:ok, archived_list} = Todo.update_list_status(list.id, true)
      assert archived_list.archived
    end

    test "update_item_status/1 mark todo list item as completed" do
      title = "Citrus Fruit"
      items = ["Orange", "Grape Fruit", "Lemon"]
      {:ok, list} = Todo.create_list_with_items(%{title: title}, items)
      [head | _] = list.items
      {:ok, item} = Todo.update_item_status(head.id, true)
      assert item.completed
    end

    test "update_item_status/1 does not mark completed when list is archived" do
      title = "Citrus Fruit"
      items = ["Orange", "Grape Fruit", "Lemon"]
      {:ok, list} = Todo.create_list_with_items(%{title: title}, items)
      {:ok, list} = Todo.update_list_status(list.id, true)
      list = Todo.get_list!(list.id)
      [head | _] = list.items
      {status, _} = Todo.update_item_status(head.id, true)
      assert status == :error
    end

  end
end
