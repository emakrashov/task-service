defmodule TaskServiceWeb.Router do
  use TaskServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TaskServiceWeb do
    pipe_through :api

    post "/tasks", TaskController, :create
  end
end
