defmodule ScavengerRideWeb.StopLiveTest do
  use ScavengerRideWeb.ConnCase

  import Phoenix.LiveViewTest
  import ScavengerRide.HuntsFixtures

  @create_attrs %{
    name: "some name",
    long: 120.5,
    prompt: "some prompt",
    lat: 120.5,
    answer: "some answer"
  }
  @update_attrs %{
    name: "some updated name",
    long: 456.7,
    prompt: "some updated prompt",
    lat: 456.7,
    answer: "some updated answer"
  }
  @invalid_attrs %{name: nil, long: nil, prompt: nil, lat: nil, answer: nil}

  defp create_stop(_) do
    stop = stop_fixture()
    %{stop: stop}
  end

  describe "Index" do
    setup [:create_stop]

    test "lists all stops", %{conn: conn, stop: stop} do
      {:ok, _index_live, html} = live(conn, ~p"/stops")

      assert html =~ "Listing Stops"
      assert html =~ stop.name
    end

    test "saves new stop", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/stops")

      assert index_live |> element("a", "New Stop") |> render_click() =~
               "New Stop"

      assert_patch(index_live, ~p"/stops/new")

      assert index_live
             |> form("#stop-form", stop: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#stop-form", stop: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/stops")

      html = render(index_live)
      assert html =~ "Stop created successfully"
      assert html =~ "some name"
    end

    test "updates stop in listing", %{conn: conn, stop: stop} do
      {:ok, index_live, _html} = live(conn, ~p"/stops")

      assert index_live |> element("#stops-#{stop.id} a", "Edit") |> render_click() =~
               "Edit Stop"

      assert_patch(index_live, ~p"/stops/#{stop}/edit")

      assert index_live
             |> form("#stop-form", stop: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#stop-form", stop: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/stops")

      html = render(index_live)
      assert html =~ "Stop updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes stop in listing", %{conn: conn, stop: stop} do
      {:ok, index_live, _html} = live(conn, ~p"/stops")

      assert index_live |> element("#stops-#{stop.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#stops-#{stop.id}")
    end
  end

  describe "Show" do
    setup [:create_stop]

    test "displays stop", %{conn: conn, stop: stop} do
      {:ok, _show_live, html} = live(conn, ~p"/stops/#{stop}")

      assert html =~ "Show Stop"
      assert html =~ stop.name
    end

    test "updates stop within modal", %{conn: conn, stop: stop} do
      {:ok, show_live, _html} = live(conn, ~p"/stops/#{stop}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Stop"

      assert_patch(show_live, ~p"/stops/#{stop}/show/edit")

      assert show_live
             |> form("#stop-form", stop: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#stop-form", stop: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/stops/#{stop}")

      html = render(show_live)
      assert html =~ "Stop updated successfully"
      assert html =~ "some updated name"
    end
  end
end
