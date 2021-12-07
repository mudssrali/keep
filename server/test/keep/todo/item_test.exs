defmodule Keep.TodoItemTest do
  use Keep.DataCase

  alias Keep.Repo
  alias Keep.Todo.Item

  describe "Item.changeset/2" do
    @invalid_attrs %{}
    @valid_attrs %{content: "Hello Item Model", list_id: "xxxxx-xxxxx-xxxxx"}


    test "changeset with invalid attributes" do
      changeset = Item.changeset(%Item{}, @invalid_attrs)
      refute changeset.valid?
    end


    test "changeset with valid attributes" do
      changeset = Item.changeset(%Item{}, @valid_attrs)
      assert changeset.valid?
    end
  end
end
