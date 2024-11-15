defmodule ScavengerRide.HuntsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ScavengerRide.Hunts` context.
  """

  @doc """
  Generate a stop.
  """
  def stop_fixture(attrs \\ %{}) do
    {:ok, stop} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        lat: 120.5,
        long: 120.5,
        name: "some name",
        prompt: "some prompt"
      })
      |> ScavengerRide.Hunts.create_stop()

    stop
  end
end
