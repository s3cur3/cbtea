defmodule CbtWeb.PageControllerTest do
  use CbtWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "CBTea provides an interface"
  end

  describe "as a logged in user" do
    setup :register_and_log_in_user

    test "redirects to /thoughts", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert redirected_to(conn) == ~p"/thoughts"
    end
  end
end
