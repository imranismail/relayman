defmodule Redis do
  def child_spec(opts) do
    merged_opts = opts(name: __MODULE__)
    merged_opts = Keyword.merge(merged_opts, opts)
    Redix.child_spec(merged_opts)
  end

  def start_link do
    Redix.start_link(opts(name: __MODULE__))
  end

  def opts(base_opts \\ []) do
    host = System.get_env("RELAYMAN_REDIS_HOST", "127.0.0.1")

    password = System.get_env("RELAYMAN_REDIS_PASSWORD")

    port =
      "RELAYMAN_REDIS_PORT"
      |> System.get_env("6379")
      |> String.to_integer()

    ssl_enabled? = System.get_env("RELAYMAN_REDIS_SSL_ENABLED") == "true"

    base_opts
    |> Keyword.put(:host, host)
    |> Keyword.put(:password, password)
    |> Keyword.put(:ssl, ssl_enabled?)
    |> Keyword.put(:port, port)
    |> Keyword.put(:socket_opts, socket_opts())
  end

  defp socket_opts do
    case System.fetch_env("RELAYMAN_REDIS_SOCKET_OPTSET") do
      {:ok, "elasticache"} ->
        [
          customize_hostname_check: [
            match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
          ]
        ]

      {:ok, _} ->
        []

      :error ->
        []
    end
  end

  def command(cmd, opts \\ []) do
    Redix.command(__MODULE__, cmd, opts)
  end

  def command!(cmd, opts \\ []) do
    Redix.command!(__MODULE__, cmd, opts)
  end

  def transaction(cmds) do
    Redix.transaction_pipeline(__MODULE__, cmds)
  end

  def transaction!(cmds) do
    Redix.transaction_pipeline!(__MODULE__, cmds)
  end
end
