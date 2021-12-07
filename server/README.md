# Keep -  Backend

To start your Phoenix server:

  * Change directory to `server`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## Mix Test

Run following commands to run `tests` using `mix test` utility

> mix test test/keep/todos

> mix test test/keep_web/controllers/todo_controller_test.esx

## Roadmap

- [ ] Write tests for Kepp.Todo.Cleanup gen-server process
- [ ] Integrate `ReactJS` with `esbuild` to make sure web ui part of Phoenix server
- [ ] Building UI with Liveview
- [ ] Add User role