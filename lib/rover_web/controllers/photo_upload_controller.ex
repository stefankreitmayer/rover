defmodule RoverWeb.PhotoUploadController do
  use RoverWeb, :controller

  # Not sure if this endpoint is the way to go.
  # Probably better to call the flask server from phoenix instead
  def upload(conn, %{"image" => image}) do
    Phoenix.PubSub.broadcast(Rover.PubSub, "photo_upload", %{photo: image})

    conn
    |> put_status(:created)
    |> json(%{ok: "image received"})
  end
end
