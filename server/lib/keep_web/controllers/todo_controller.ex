defmodule KeepWeb.TodoController do
  use KeepWeb, :controller

  alias Keep.Todo

  @doc false
  def index(conn, _params) do
    todos = Todo.all()
    render(conn, "index.html", todos: todos)
  end

  @doc false
  def new(conn, _params) do
    render(conn, "new.html")
  end
end
