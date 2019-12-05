defmodule RelaymanWeb.SourceChannel do
  use Phoenix.Channel

  def join("source:" <> _source, _message, socket) do
    {:ok, socket}
  end
end
