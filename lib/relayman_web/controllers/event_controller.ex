defmodule RelaymanWeb.EventController do
  use RelaymanWeb, :controller
  use Parameters

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
    topic = "source:#{params["source"]}"
    event = params["type"]

    Endpoint.broadcast!(topic, event, params)

    conn
    |> put_status(:created)
    |> json(params)
  end
end
