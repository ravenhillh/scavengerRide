defmodule ScavengerRide.ScavPointsTest do
  use ScavengerRide.DataCase

  alias ScavengerRide.ScavPoints

  describe "points" do
    alias ScavengerRide.ScavPoints.Point

    import ScavengerRide.ScavPointsFixtures

    @invalid_attrs %{name: nil, long: nil, prompt: nil, lat: nil, answer: nil}

    test "list_points/0 returns all points" do
      point = point_fixture()
      assert ScavPoints.list_points() == [point]
    end

    test "get_point!/1 returns the point with given id" do
      point = point_fixture()
      assert ScavPoints.get_point!(point.id) == point
    end

    test "create_point/1 with valid data creates a point" do
      valid_attrs = %{
        name: "some name",
        long: 120.5,
        prompt: "some prompt",
        lat: 120.5,
        answer: "some answer"
      }

      assert {:ok, %Point{} = point} = ScavPoints.create_point(valid_attrs)
      assert point.name == "some name"
      assert point.long == 120.5
      assert point.prompt == "some prompt"
      assert point.lat == 120.5
      assert point.answer == "some answer"
    end

    test "create_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ScavPoints.create_point(@invalid_attrs)
    end

    test "update_point/2 with valid data updates the point" do
      point = point_fixture()

      update_attrs = %{
        name: "some updated name",
        long: 456.7,
        prompt: "some updated prompt",
        lat: 456.7,
        answer: "some updated answer"
      }

      assert {:ok, %Point{} = point} = ScavPoints.update_point(point, update_attrs)
      assert point.name == "some updated name"
      assert point.long == 456.7
      assert point.prompt == "some updated prompt"
      assert point.lat == 456.7
      assert point.answer == "some updated answer"
    end

    test "update_point/2 with invalid data returns error changeset" do
      point = point_fixture()
      assert {:error, %Ecto.Changeset{}} = ScavPoints.update_point(point, @invalid_attrs)
      assert point == ScavPoints.get_point!(point.id)
    end

    test "delete_point/1 deletes the point" do
      point = point_fixture()
      assert {:ok, %Point{}} = ScavPoints.delete_point(point)
      assert_raise Ecto.NoResultsError, fn -> ScavPoints.get_point!(point.id) end
    end

    test "change_point/1 returns a point changeset" do
      point = point_fixture()
      assert %Ecto.Changeset{} = ScavPoints.change_point(point)
    end
  end
end
