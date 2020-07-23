defmodule RelaymanWeb.SourceChannel do
  use Phoenix.Channel

  alias Relayman.EventStore

  def join("source:" <> source, params, socket) do
    send(self(), {:after_join, params})
    {:ok, assign(socket, :source, source)}
  end

  def handle_info({:after_join, params}, socket) do
    with last_event_id when not is_nil(last_event_id) <-
           Map.get(params, "last_event_id"),
         {:ok, events} when is_list(events) <-
           EventStore.read_from(socket.assigns.source, params["last_event_id"]) do
      push(socket, "events", %{data: events})
    end

    {:noreply, socket}
  end
end
