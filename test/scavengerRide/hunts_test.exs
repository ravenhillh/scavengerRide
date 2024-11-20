defmodule ScavengerRide.HuntsTest do
  use ScavengerRide.DataCase

  alias ScavengerRide.Hunts

  describe "stops" do
    alias ScavengerRide.Hunts.Stop

    import ScavengerRide.HuntsFixtures

    @invalid_attrs %{name: nil, long: nil, prompt: nil, lat: nil, answer: nil}

    test "list_stops/0 returns all stops" do
      stop = stop_fixture()
      assert Hunts.list_stops() == [stop]
    end

    test "get_stop!/1 returns the stop with given id" do
      stop = stop_fixture()
      assert Hunts.get_stop!(stop.id) == stop
    end

    test "create_stop/1 with valid data creates a stop" do
      valid_attrs = %{
        name: "some name",
        long: 120.5,
        prompt: "some prompt",
        lat: 120.5,
        answer: "some answer"
      }

      assert {:ok, %Stop{} = stop} = Hunts.create_stop(valid_attrs)
      assert stop.name == "some name"
      assert stop.long == 120.5
      assert stop.prompt == "some prompt"
      assert stop.lat == 120.5
      assert stop.answer == "some answer"
    end

    test "create_stop/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hunts.create_stop(@invalid_attrs)
    end

    test "update_stop/2 with valid data updates the stop" do
      stop = stop_fixture()

      update_attrs = %{
        name: "some updated name",
        long: 456.7,
        prompt: "some updated prompt",
        lat: 456.7,
        answer: "some updated answer"
      }

      assert {:ok, %Stop{} = stop} = Hunts.update_stop(stop, update_attrs)
      assert stop.name == "some updated name"
      assert stop.long == 456.7
      assert stop.prompt == "some updated prompt"
      assert stop.lat == 456.7
      assert stop.answer == "some updated answer"
    end

    test "update_stop/2 with invalid data returns error changeset" do
      stop = stop_fixture()
      assert {:error, %Ecto.Changeset{}} = Hunts.update_stop(stop, @invalid_attrs)
      assert stop == Hunts.get_stop!(stop.id)
    end

    test "delete_stop/1 deletes the stop" do
      stop = stop_fixture()
      assert {:ok, %Stop{}} = Hunts.delete_stop(stop)
      assert_raise Ecto.NoResultsError, fn -> Hunts.get_stop!(stop.id) end
    end

    test "change_stop/1 returns a stop changeset" do
      stop = stop_fixture()
      assert %Ecto.Changeset{} = Hunts.change_stop(stop)
    end
  end
end
