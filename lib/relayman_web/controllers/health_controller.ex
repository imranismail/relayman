defmodule RelaymanWeb.HealthzController do
  use RelaymanWeb, :controller

  def index(conn, _params) do
    status = %{
      status: 200,
      message: "OK"
    }

    conn
    |> put_status(:ok)
    |> json(status)
  end
end
