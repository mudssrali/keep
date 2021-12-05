# Keep

To start your Phoenix server:

  * Change directory to `server`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Docker - Database

Create and run postgres `db` inside docker container

```bash
docker run -p 5432:5432 -d \                
    --name keep-app \                                                             
    -e POSTGRES_DB=keep_dev \    
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_USER=postgres \
    -v /docker/keep-app/db:/var/lib/postgresql/data \
    postgres:14.1
```

Get into running docker container

```tsx
docker exec -it keep-app psql -U postgres -d keep_dev
```