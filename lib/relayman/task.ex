defmodule Relayman.Task do
  alias Relayman.EventStore

  require Logger

  def prune_sources, do: prune!()

  def prune! do
    perform(fn ->
      Logger.info(inspect(EventStore.prune!()))
    end)
  end

  def list! do
    perform(fn ->
      Logger.info(inspect(EventStore.list!()))
    end)
  end

  defp perform(fun) do
    Application.ensure_all_started(:relayman)

    Logger.info("Starting...")

    start = System.system_time(:millisecond)

    fun.()

    stop = System.system_time(:millisecond)

    Logger.info("Finished in #{stop - start}ms")
  after
    Application.stop(:relayman)
  end
end
