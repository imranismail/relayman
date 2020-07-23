defmodule Relayman.EventStore do
  alias RelaymanWeb.Endpoint
  alias Redis.Command, as: CMD

  def create(event) do
    event = Map.put(event, :id, UUID.uuid4())
    timestamp = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    source = "source:#{event[:source]}"
    type = event[:type]

    transaction =
      Redis.transaction([
        CMD.set(event.id, event, ~w[PX #{:timer.hours(24)}]),
        CMD.zadd(source, timestamp, event.id)
      ])

    with {:ok, ["OK", 1]} <- transaction,
         :ok <- Endpoint.broadcast!(source, type, event) do
      {:ok, event}
    end
  end

  def read_from(source, event_id) do
    with {:ok, score} when is_binary(score) <-
           Redis.command(CMD.zscore("source:#{source}", event_id)),
         {:ok, event_ids} when is_list(event_ids) <-
           Redis.command(CMD.zrange_by_score_gt("source:#{source}", score)),
         {:ok, events} <-
           Redis.command(CMD.multi_get(event_ids)) do
      {:ok, Redis.Coder.decode(events)}
    end
  end

  def list_sources do
    Redis.command(CMD.keys("source:*"))
  end

  def clear_sources do
    with {:ok, keys} <- list_sources() do
      Redis.transaction(Enum.map(keys, &CMD.delete/1))
    end
  end
end
