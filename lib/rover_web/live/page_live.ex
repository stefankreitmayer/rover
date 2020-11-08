defmodule RoverWeb.PageLive do
  use RoverWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rover.PubSub, "photo_upload")
    {:ok, socket}
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
end
