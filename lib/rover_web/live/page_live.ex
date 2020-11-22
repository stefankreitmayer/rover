defmodule RoverWeb.PageLive do
  use RoverWeb, :live_view

  @api_root "morty.local:5000/api/v1"

  @impl true
  def mount(_params, _session, socket) do
    # Phoenix.PubSub.subscribe(Rover.PubSub, "photo_upload") # deprecated
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
  def handle_info(:movement_complete, socket) do
    {:noreply, socket |> assign(motor_feedback: nil) |> fetch_photo()}
  end

  @impl true
  def handle_info(%{photo: image}, socket) do
    {:noreply, socket |> assign(photo: image)}
  end

  defp move(socket, left, right) do
    duration = 300
    left = left * 0.3
    right = right * 0.3
    if socket.assigns[:motor_feedback] do
      socket
    else
      Process.send_after(self(), :movement_complete, duration)
      message =
        case request_robot_move(left, right, duration) do
          :ok ->
            "#{left}  #{right}"
          {:error, message} ->
            message
        end
      socket
      |> assign(:motor_feedback, message)
    end
  end

  defp request_robot_move(left, right, duration) do
    url = "#{@api_root}/move"
    try do
      body = %{"left_speed" => left, "right_speed" => right, "duration" => duration}
      json = Jason.encode!(body)
      response = HTTPoison.post!(url, json, [{"Content-Type", "application/json"}])
      case response.status_code do
        200 -> :ok
        _ -> {:error, "HTTP response code: #{response.status_code}"}
      end
    rescue
      e -> {:error, "Error: #{e.reason}"}
    end
  end

  defp fetch_photo(socket) do
    socket
    |> assign(:photo, fetch_photo_html())
  end

  defp fetch_photo_html do
    url = "#{@api_root}/snap"
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
