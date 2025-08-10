defmodule CbtWeb.ThoughtsLiveTest do
  use CbtWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "sets the page title", %{conn: conn} do
    {:ok, live_view, _html} = live(conn, ~p"/thoughts")
    assert page_title(live_view) == "Thoughts · CBTea · The Cognitive Behavioral Therapy App"
  end

  test "creates a new thought using the form", %{conn: conn} do
    Cbt.SeedHelpers.apply_seeds()

    conn
    |> visit(~p"/")
    |> fill_in("Automatic thought", with: "I'm going to fail this test")
    |> fill_in("Challenge", with: "What evidence do I have for this thought?")
    |> fill_in("Alternative thought", with: "I can prepare and do my best")
    |> check("All or Nothing Thinking", exact: false)
    |> check("Fortune Telling", exact: false)
    |> click_button("Save")
    # Verify the thought was created and appears in the list
    |> assert_has("[data-qa='recorded-thought']", text: "I'm going to fail this test")
    |> assert_has("[data-qa='recorded-thought']",
      text: "What evidence do I have for this thought?"
    )
    |> assert_has("[data-qa='recorded-thought']", text: "I can prepare and do my best")
    |> assert_has("[data-qa='distortion']", text: "All or Nothing Thinking")
    |> assert_has("[data-qa='distortion']", text: "Fortune Telling")
    |> assert_has("input[value='']")
  end
end
