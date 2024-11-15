defmodule ScavengerRideWeb.PointLive.Index do
  use ScavengerRideWeb, :live_view

  alias ScavengerRide.ScavPoints
  alias ScavengerRide.ScavPoints.Point

  @impl true
  def mount(_params, _session, socket) do
    changeset = ScavengerRide.ScavPoints.change_point(%Point{})

    socket =
      socket
      |> assign(changeset: changeset)

    {:ok, stream(socket, :points, ScavPoints.list_points())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Point")
    |> assign(:point, ScavPoints.get_point!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Point")
    |> assign(:point, %Point{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Points")
    |> assign(:point, nil)
  end

  @impl true
  def handle_info({ScavengerRideWeb.PointLive.FormComponent, {:saved, point}}, socket) do
    {:noreply, stream_insert(socket, :points, point)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    point = ScavPoints.get_point!(id)
    {:ok, _} = ScavPoints.delete_point(point)

    {:noreply, stream_delete(socket, :points, point)}
  end

  def handle_event("map-click", %{"lat" => lat, "long" => long}, socket) do
    # Update the changeset with the new latitude and longitude values
    # IO.inspect(socket.assigns)
    # updated_changeset =
    #   socket.assigns.changeset
    #   |> Ecto.Changeset.change(%{lat: lat, long: long})
    socket = assign(socket, %{lat: lat, long: long})
    IO.inspect(socket)
    # Assign the updated changeset back to the socket
    {:noreply, socket}
  end

  # def handle_event("new-point", _, socket) do
  #   changeset = Ecto.Changeset.change(%Point{}, %{lat: socket.assigns.lat, long: socket.assigns.long})
  #   {:noreply, assign(socket, changeset: changeset, live_action: :new)}
  # end
  def handle_event("new-point", _, socket) do
    {:noreply,
     socket
     |> assign(:form, to_form(%{}))
     |> push_patch(to: ~p"/points/new")}
  end
end
