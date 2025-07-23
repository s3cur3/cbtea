defmodule CbtWeb.ThoughtsLiveTest do
  use CbtWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "sets the page title", %{conn: conn} do
    {:ok, live_view, _html} = live(conn, ~p"/thoughts")
    assert page_title(live_view) == "Thoughts · CBTea · The Cognitive Behavioral Therapy App"
  end
end
