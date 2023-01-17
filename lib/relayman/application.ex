defmodule Relayman.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the redis connection
      Redis,
      # Start the pubsub
      {Phoenix.PubSub, pub_sub_opts()},
      # Start the endpoint when the application starts
      RelaymanWeb.Endpoint
      # Starts a worker by calling: Relayman.Worker.start_link(arg)
      # {Relayman.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Relayman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RelaymanWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp pub_sub_opts do
    base_opts = [name: RelaymanWeb.PubSub]

    case System.fetch_env("RELAYMAN_PUBSUB_ADAPTER") do
      {:ok, "redis"} ->
        redis_opts(base_opts)

      {:ok, _} ->
        base_opts

      :error ->
        base_opts
    end
  end

  defp redis_opts(base_opts) do
    pool_size =
      "RELAYMAN_REDIS_POOL_SIZE"
      |> System.get_env("5")
      |> String.to_integer()

    base_opts
    |> Redis.opts()
    |> Keyword.put(:adapter, Phoenix.PubSub.Redis)
    |> Keyword.put(:redis_pool_size, pool_size)
    |> Keyword.put(:node_name, System.fetch_env!("RELEASE_NODE"))
  end
end
