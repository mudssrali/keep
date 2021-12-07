defmodule Keep.TodoListTest do
  use Keep.DataCase

  alias Keep.Repo
  alias Keep.Todo.List

  describe "List.changeset/2" do
    @invalid_attrs %{}
    @valid_attrs %{title: "Hello List Model"}

    test "changeset with invalid attributes" do
      changeset = List.changeset(%List{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "changeset with valid attributes" do
      changeset = List.changeset(%List{}, @valid_attrs)
      assert changeset.valid?
    end
  end
end
