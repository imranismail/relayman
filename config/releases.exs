import Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

port =
  System.get_env("PORT")
  |> Kernel.||("4000")
  |> String.to_integer()

config :relayman, RelaymanWeb.Endpoint,
  http: [:inet6, port: port],
  secret_key_base: secret_key_base

config :relayman, RelaymanWeb.Endpoint,
  server: System.get_env("RELAYMAN_SERVER_ENABLED", "true") == "true"
