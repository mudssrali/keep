defmodule KeepWeb.TodoControllerTest do
  use KeepWeb.ConnCase

  alias Keep.Repo
  alias Keep.Todo

  describe "GET api/lists/ api/list?id=" do
    @valid_attrs %{title: "Coding Styles"}

    def list_fixture(attrs \\ %{}) do
      with create_attrs <- Enum.into(attrs, @valid_attrs),
           {:ok, list} <- Todo.create_list(create_attrs),
           list <- Repo.preload(list, :items) do
        list
      end
    end

    test "get_lists renders a todo lists" do
      conn = build_conn()
      conn = get(conn, Routes.todo_path(conn, :get_lists))
      assert json_response(conn, 200)

      # checking serialization
      assert json_response(conn, 200) == %{
        "data" => [],
        "status" => "success",
        "code" => 200
      }
    end

    test "get_list renders a single todo list" do
      conn = build_conn()
      todo = list_fixture()

      conn = get(conn, Routes.todo_path(conn, :get_list, %{id: todo.id}))

      # assert response
      assert json_response(conn, 200)

      # checking serialization
      assert json_response(conn, 200) == %{
               "data" => %{
                 "id" => todo.id,
                 "title" => todo.title,
                 "archived" => todo.archived,
                 "inserted_at" => NaiveDateTime.to_iso8601(todo.inserted_at),
                 "updated_at" => NaiveDateTime.to_iso8601(todo.updated_at),
                 "items" => todo.items
               },
               "error" => nil,
               "status" => "success",
               "code" => 200
             }
    end
  end

  describe "todo-create-update-archive" do
    test  "create list" do
      conn = build_conn()
      conn = post(conn, Routes.todo_path(conn, :create_list, %{"title" => "Web3"}))
      
      assert json_response(conn, 200)

      json_response = json_response(conn, 200)
      list =  Map.get(json_response, "data")
      
      assert list["title"] == "Web3"
    end
  end

end
