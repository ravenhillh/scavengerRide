defmodule ScavengerRideWeb.StopLive.Show do
  use ScavengerRideWeb, :live_view

  alias ScavengerRide.Hunts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:stop, Hunts.get_stop!(id))}
  end

  defp page_title(:show), do: "Show Stop"
  defp page_title(:edit), do: "Edit Stop"
end
