defmodule RelaymanWeb.SourceChannel do
  use Phoenix.Channel

  alias Relayman.EventStore

  def join("source:" <> source, params, socket) do
    send(self(), {:after_join, params})
    {:ok, assign(socket, :source, source)}
  end

  def handle_info({:after_join, params}, socket) do
    with {:ok, last_event_id} <-
           Map.fetch(params, "last_event_id"),
         {:ok, events} <-
           EventStore.read_from(socket.assigns.source, last_event_id) do
      push(socket, "events", %{data: events})
    end

    {:noreply, socket}
  end
end
