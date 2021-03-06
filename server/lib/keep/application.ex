defmodule Keep.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Keep.Repo,
      # Start the Telemetry supervisor
      KeepWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Keep.PubSub},
      # Start the Endpoint (http/https)
      KeepWeb.Endpoint,
      # Start a worker by calling: Keep.Worker.start_link(arg)
      # {Keep.Worker, arg}

      # Start Cleanup Server 
      Keep.Todo.Cleanup
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Keep.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KeepWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
