defmodule RelaymanWeb.SourceChannel do
  use Phoenix.Channel

  def join("source:/", _message, socket) do
    {:ok, socket}
  end

  def join("source:" <> _source, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
