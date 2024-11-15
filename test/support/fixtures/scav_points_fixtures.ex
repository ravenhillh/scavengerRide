defmodule ScavengerRide.ScavPointsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ScavengerRide.ScavPoints` context.
  """

  @doc """
  Generate a point.
  """
  def point_fixture(attrs \\ %{}) do
    {:ok, point} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        lat: 120.5,
        long: 120.5,
        name: "some name",
        prompt: "some prompt"
      })
      |> ScavengerRide.ScavPoints.create_point()

    point
  end
end
