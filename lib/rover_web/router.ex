defmodule RoverWeb.Router do
  use RoverWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RoverWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RoverWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/api/v1", RoverWeb do
    pipe_through :api
    post "/photo", PhotoUploadController, :upload
  end
end
