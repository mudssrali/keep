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
    test "create todo list" do
      conn = build_conn()
      conn = post(conn, Routes.todo_path(conn, :create_list, %{"title" => "Web3"}))
      assert json_response(conn, 200)
      json_response = json_response(conn, 200)
      list = Map.get(json_response, "data")
      assert list["title"] == "Web3"
    end

    test "update recently created todo list" do
      conn = build_conn()
      conn = post(conn, Routes.todo_path(conn, :create_list, %{"title" => "Web3"}))

      assert json_response(conn, 200)
      list = Map.get(json_response(conn, 200), "data")

      conn =
        post(
          conn,
          Routes.todo_path(conn, :update_list, %{
            "title" => "Web2.0 Still works",
            "list_id" => list["id"]
          })
        )

      assert json_response(conn, 200)
      updated_list = Map.get(json_response(conn, 200), "data")
      assert list["title"] != updated_list["title"]
    end

    test "create an item for a todo list" do
      conn = build_conn()
      conn = post(conn, Routes.todo_path(conn, :create_list, %{"title" => "Web3"}))

      list = Map.get(json_response(conn, 200), "data")

      new_item = %{
        "list_id" => list["id"],
        "content" => "Decentralization"
      }

      conn = post(conn, Routes.todo_path(conn, :create_item, new_item))
      assert json_response(conn, 200)
      item = Map.get(json_response(conn, 200), "data")
      assert item["content"] == new_item["content"]
    end

        test "update an item" do
      conn = build_conn()
      conn = post(conn, Routes.todo_path(conn, :create_list, %{"title" => "Web3"}))

      list = Map.get(json_response(conn, 200), "data")

      new_item = %{
        "list_id" => list["id"],
        "content" => "Decentralization"
      }

      conn = post(conn, Routes.todo_path(conn, :create_item, new_item))
      item = Map.get(json_response(conn, 200), "data")

      update_item = %{
        "item_id" => item["id"],
        "content" => "Decentralization - Expensive"
      }

      conn = post(conn, Routes.todo_path(conn, :update_item, update_item))

      updated_item = Map.get(json_response(conn, 200), "data")
      assert item["content"] != updated_item["content"]
    end
    

  end
end
