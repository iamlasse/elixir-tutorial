defmodule TutorialWeb.CMS.FlokControllerTest do
  use TutorialWeb.ConnCase

  alias Tutorial.CMS

  @create_attrs %{description: "some description", published: "some published", sport: "some sport", title: "some title"}
  @update_attrs %{description: "some updated description", published: "some updated published", sport: "some updated sport", title: "some updated title"}
  @invalid_attrs %{description: nil, published: nil, sport: nil, title: nil}

  def fixture(:flok) do
    {:ok, flok} = CMS.create_flok(@create_attrs)
    flok
  end

  describe "index" do
    test "lists all floks", %{conn: conn} do
      conn = get conn, cms_flok_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Floks"
    end
  end

  describe "new flok" do
    test "renders form", %{conn: conn} do
      conn = get conn, cms_flok_path(conn, :new)
      assert html_response(conn, 200) =~ "New Flok"
    end
  end

  describe "create flok" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, cms_flok_path(conn, :create), flok: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == cms_flok_path(conn, :show, id)

      conn = get conn, cms_flok_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Flok"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, cms_flok_path(conn, :create), flok: @invalid_attrs
      assert html_response(conn, 200) =~ "New Flok"
    end
  end

  describe "edit flok" do
    setup [:create_flok]

    test "renders form for editing chosen flok", %{conn: conn, flok: flok} do
      conn = get conn, cms_flok_path(conn, :edit, flok)
      assert html_response(conn, 200) =~ "Edit Flok"
    end
  end

  describe "update flok" do
    setup [:create_flok]

    test "redirects when data is valid", %{conn: conn, flok: flok} do
      conn = put conn, cms_flok_path(conn, :update, flok), flok: @update_attrs
      assert redirected_to(conn) == cms_flok_path(conn, :show, flok)

      conn = get conn, cms_flok_path(conn, :show, flok)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, flok: flok} do
      conn = put conn, cms_flok_path(conn, :update, flok), flok: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Flok"
    end
  end

  describe "delete flok" do
    setup [:create_flok]

    test "deletes chosen flok", %{conn: conn, flok: flok} do
      conn = delete conn, cms_flok_path(conn, :delete, flok)
      assert redirected_to(conn) == cms_flok_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, cms_flok_path(conn, :show, flok)
      end
    end
  end

  defp create_flok(_) do
    flok = fixture(:flok)
    {:ok, flok: flok}
  end
end
