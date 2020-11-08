defmodule RoverWeb.PhotoUploadController do
  use RoverWeb, :controller

  def upload(conn, %{"image" => image}) do
    Phoenix.PubSub.broadcast(Rover.PubSub, "photo_upload", %{photo: image})

    conn
    |> put_status(:created)
    |> json(%{ok: "image received"})
  end
end
