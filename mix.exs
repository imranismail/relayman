defmodule Relayman.MixProject do
  use Mix.Project

  def project do
    [
      app: :relayman,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Relayman.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_pubsub_redis, "~> 3.0"},
      {:plug_cowboy, "~> 2.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:parameters, "~> 2.0"},
      {:elixir_uuid, "~> 1.2"},
      {:redix, ">= 0.0.0"},
      {:castore, ">= 0.0.0"}
    ]
  end

  defp releases do
    [
      relayman: [
        include_erts: true,
        include_executables_for: [:unix],
        applications: [runtime_tools: :permanent]
      ]
    ]
  end
end
