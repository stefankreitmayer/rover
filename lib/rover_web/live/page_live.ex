defmodule RoverWeb.PageLive do
  use RoverWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rover.PubSub, "photo_upload") # deprecated
    {:ok, socket |> fetch_photo()}
  end

  @impl true
  def handle_event("forward", _, socket) do
    {:noreply, socket |> move(1, 1)}
  end

  @impl true
  def handle_event("backward", _, socket) do
    {:noreply, socket |> move(-1, -1)}
  end

  @impl true
  def handle_event("left", _, socket) do
    {:noreply, socket |> move(-1, 1)}
  end

  @impl true
  def handle_event("right", _, socket) do
    {:noreply, socket |> move(1, -1)}
  end

  @impl true
  def handle_info(:stop_motors, socket) do
    {:noreply, socket |> assign(movement: nil)}
  end

  @impl true
  def handle_info(%{photo: image}, socket) do
    {:noreply, socket |> assign(photo: image)}
  end

  def move(socket, left, right) do
    if socket.assigns[:movement] do
      socket
    else
      Process.send_after(self(), :stop_motors, 1000)
      socket
      |> assign(:movement, "#{left}  #{right}")
    end
  end

  defp fetch_photo(socket) do
    socket
    |> assign(:photo, fetch_photo_html())
  end

  defp fetch_photo_html do
    url = "morty.local:5000/api/v1/snap"
    try do
      response = HTTPoison.get!(url)
      data = Jason.decode!(response.body)
      image_data = data["image"]
      {:ok, "data:image/jpeg;base64,#{image_data}"}
    rescue
      e -> {:error, "Error: #{e.reason}"}
    end

  end
end
