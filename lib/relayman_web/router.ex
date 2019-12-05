defmodule RelaymanWeb.Router do
  use RelaymanWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RelaymanWeb do
    pipe_through :api

    get "/healthz", HealthzController, :index
    post "/events", EventController, :create
  end
end
