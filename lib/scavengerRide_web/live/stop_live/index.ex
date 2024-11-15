defmodule ScavengerRideWeb.StopLive.Index do
  use ScavengerRideWeb, :live_view

  alias ScavengerRide.Hunts
  alias ScavengerRide.Hunts.Stop

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :stops, Hunts.list_stops())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Stop")
    |> assign(:stop, Hunts.get_stop!(id))
  end

  defp apply_action(socket, :new, _params) do
    # IO.inspect(socket.assigns)
    socket
    |> assign(:page_title, "New Stop")
    |> assign(:stop, %Stop{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stops")
    |> assign(:stop, nil)
  end

  @impl true
  def handle_info({ScavengerRideWeb.StopLive.FormComponent, {:saved, stop}}, socket) do
    {:noreply, stream_insert(socket, :stops, stop)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    stop = Hunts.get_stop!(id)
    {:ok, _} = Hunts.delete_stop(stop)

    {:noreply, stream_delete(socket, :stops, stop)}
  end

  def handle_event("map-click", %{"lat" => lat, "long" => long}, socket) do
    socket = assign(socket, lat: lat, long: long)

    {:noreply, socket}
  end
end
