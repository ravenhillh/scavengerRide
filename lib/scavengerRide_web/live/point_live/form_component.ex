defmodule ScavengerRideWeb.PointLive.FormComponent do
  use ScavengerRideWeb, :live_component

  alias ScavengerRide.ScavPoints

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage point records in your database.</:subtitle>
      </.header>
      <.simple_form
        for={%{}}
        id="point-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%!-- <.input field={@form[:long]} type="hidden" name="lat" value={@lat} />
        <.input field={@form[:long]} type="hidden" name="long" value={@long} /> --%>
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:prompt]} type="text" label="Prompt" />
        <.input field={@form[:answer]} type="text" label="Answer" />

        <:actions>
          <.button type="submit" phx-disable-with="Saving...">Save Point</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{point: point} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ScavPoints.change_point(point))
     end)}
  end

  @impl true
  def handle_event("validate", %{"point" => point_params}, socket) do
    changeset = ScavPoints.change_point(socket.assigns.point, point_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"point" => point_params}, socket) do
    IO.inspect(socket.assigns)
    save_point(socket, socket.assigns.action, point_params)
  end

  defp save_point(socket, :edit, point_params) do
    case ScavPoints.update_point(socket.assigns.point, point_params) do
      {:ok, point} ->
        notify_parent({:saved, point})

        {:noreply,
         socket
         |> put_flash(:info, "Point updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_point(socket, :new, point_params) do
    # Merge changes from the current changeset, which could have lat/long, with the submitted form data

    merged_params = Map.merge(point_params, %{"lat" => 30, "long" => 90})
    IO.inspect(point_params)

    case ScavPoints.create_point(merged_params) do
      {:ok, point} ->
        IO.inspect("ok")
        notify_parent({:saved, point})

        {:noreply,
         socket
         |> put_flash(:info, "Point created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
