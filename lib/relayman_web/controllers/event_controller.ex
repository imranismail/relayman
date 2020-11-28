defmodule RelaymanWeb.EventController do
  use RelaymanWeb, :controller
  use Parameters

  alias Relayman.EventStore

  plug Parameters.Sanitizer

  params do
    requires :specversion, :string, default: "1.0"
    requires :id, :string
    requires :source, :string
    requires :type, :string
    optional :datacontenttype, :string
    optional :dataschema, :string
    optional :subject, :string
    optional :time, :string
    optional :data, :map
  end

  def create(conn, params) do
    {:ok, event} = EventStore.create(params)

    conn
    |> put_status(:created)
    |> json(event)
  end
end
