defmodule Keep.Repo do
  use Ecto.Repo,
    otp_app: :keep,
    adapter: Ecto.Adapters.Postgres
end
