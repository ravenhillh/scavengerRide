defmodule ScavengerRide.Hunts.Stop do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stops" do
    field :name, :string
    field :long, :float
    field :prompt, :string
    field :lat, :float
    field :answer, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stop, attrs) do
    stop
    |> cast(attrs, [:name, :lat, :long, :prompt, :answer])
    |> validate_required([:name, :lat, :long, :prompt, :answer])
  end
end
