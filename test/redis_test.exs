defmodule RedisTest do
  use ExUnit.Case

  @env_keys [
    "RELAYMAN_REDIS_HOST",
    "RELAYMAN_REDIS_SSL_ENABLED",
    "RELAYMAN_REDIS_SOCKET_OPTSET",
    "RELAYMAN_REDIS_SSL_VERIFY_HOSTNAME"
  ]

  setup do
    original = Map.new(@env_keys, fn key -> {key, System.get_env(key)} end)

    on_exit(fn ->
      Enum.each(original, fn
        {key, nil} -> System.delete_env(key)
        {key, value} -> System.put_env(key, value)
      end)
    end)

    :ok
  end

  test "skips ssl hostname verification when disabled" do
    System.put_env("RELAYMAN_REDIS_SOCKET_OPTSET", "elasticache")
    System.put_env("RELAYMAN_REDIS_SSL_VERIFY_HOSTNAME", "false")

    assert Keyword.get(Redis.opts(), :socket_opts) == [verify: :verify_none]
  end

  test "uses elasticache hostname check by default" do
    System.put_env("RELAYMAN_REDIS_SOCKET_OPTSET", "elasticache")
    System.delete_env("RELAYMAN_REDIS_SSL_VERIFY_HOSTNAME")

    socket_opts = Keyword.get(Redis.opts(), :socket_opts)
    assert Keyword.has_key?(socket_opts, :customize_hostname_check)
    refute Keyword.has_key?(socket_opts, :verify)
  end
end
