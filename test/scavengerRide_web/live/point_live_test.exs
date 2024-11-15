defmodule ScavengerRideWeb.PointLiveTest do
  use ScavengerRideWeb.ConnCase

  import Phoenix.LiveViewTest
  import ScavengerRide.ScavPointsFixtures

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

  defp create_point(_) do
    point = point_fixture()
    %{point: point}
  end

  describe "Index" do
    setup [:create_point]

    test "lists all points", %{conn: conn, point: point} do
      {:ok, _index_live, html} = live(conn, ~p"/points")

      assert html =~ "Listing Points"
      assert html =~ point.name
    end

    test "saves new point", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/points")

      assert index_live |> element("a", "New Point") |> render_click() =~
               "New Point"

      assert_patch(index_live, ~p"/points/new")

      assert index_live
             |> form("#point-form", point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#point-form", point: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/points")

      html = render(index_live)
      assert html =~ "Point created successfully"
      assert html =~ "some name"
    end

    test "updates point in listing", %{conn: conn, point: point} do
      {:ok, index_live, _html} = live(conn, ~p"/points")

      assert index_live |> element("#points-#{point.id} a", "Edit") |> render_click() =~
               "Edit Point"

      assert_patch(index_live, ~p"/points/#{point}/edit")

      assert index_live
             |> form("#point-form", point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#point-form", point: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/points")

      html = render(index_live)
      assert html =~ "Point updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes point in listing", %{conn: conn, point: point} do
      {:ok, index_live, _html} = live(conn, ~p"/points")

      assert index_live |> element("#points-#{point.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#points-#{point.id}")
    end
  end

  describe "Show" do
    setup [:create_point]

    test "displays point", %{conn: conn, point: point} do
      {:ok, _show_live, html} = live(conn, ~p"/points/#{point}")

      assert html =~ "Show Point"
      assert html =~ point.name
    end

    test "updates point within modal", %{conn: conn, point: point} do
      {:ok, show_live, _html} = live(conn, ~p"/points/#{point}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Point"

      assert_patch(show_live, ~p"/points/#{point}/show/edit")

      assert show_live
             |> form("#point-form", point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#point-form", point: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/points/#{point}")

      html = render(show_live)
      assert html =~ "Point updated successfully"
      assert html =~ "some updated name"
    end
  end
end
