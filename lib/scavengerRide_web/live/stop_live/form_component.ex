defmodule ScavengerRideWeb.StopLive.FormComponent do
  use ScavengerRideWeb, :live_component

  alias ScavengerRide.Hunts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage stop records in your database.</:subtitle>
      </.header>
      <.simple_form
        for={@form}
        id="stop-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div style="display: none;">
          <.input field={@form[:lat]} type="number" label="Lat" />
          <.input field={@form[:long]} type="number" label="Long" />
        </div>
        <.input field={@form[:name]} type="text" label="Name" />
        <%!-- <.input field={@form[:lat]} type="number" label="Lat" step="any" />
        <.input field={@form[:long]} type="number" label="Long" step="any" /> --%>
        <.input field={@form[:prompt]} type="text" label="Prompt" />
        <.input field={@form[:answer]} type="text" label="Answer" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Stop</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{stop: stop} = assigns, socket) do
    IO.inspect("in form update")
    IO.inspect(assigns)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Hunts.change_stop(stop))
     end)}
  end

  @impl true
  def handle_event("validate", %{"stop" => stop_params}, socket) do
    changeset = Hunts.change_stop(socket.assigns.stop, stop_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"stop" => stop_params}, socket) do
    save_stop(socket, socket.assigns.action, stop_params)
  end

  defp save_stop(socket, :edit, stop_params) do
    case Hunts.update_stop(socket.assigns.stop, stop_params) do
      {:ok, stop} ->
        notify_parent({:saved, stop})

        {:noreply,
         socket
         |> put_flash(:info, "Stop updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_stop(socket, :new, stop_params) do
    case Hunts.create_stop(stop_params) do
      {:ok, stop} ->
        notify_parent({:saved, stop})

        {:noreply,
         socket
         |> put_flash(:info, "Stop created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
