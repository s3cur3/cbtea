defmodule CbtWeb.JournalLiveTest do
  use CbtWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Cbt.Journal
  alias Cbt.Repo

  setup :register_and_log_in_user

  @create_attrs %{
    notes: "Had a great day today!",
    mood_rating: 4,
    inserted_at: ~N[2024-01-15 00:00:00]
  }

  describe "Index" do
    test "redirects if user is not logged in" do
      # Build a fresh conn without authentication
      fresh_conn = Phoenix.ConnTest.build_conn()
      assert {:error, {:redirect, %{to: path}}} = live(fresh_conn, ~p"/journal")
      assert path =~ ~p"/users/log_in"
    end

    test "shows journal entries for logged in user", %{conn: conn, user: user} do
      {:ok, _} = Journal.create_entry(user, @create_attrs)

      conn
      |> visit(~p"/journal")
      |> assert_has("[data-qa='journal-entry']", text: @create_attrs.notes)
      |> assert_has("[data-qa='journal-entry']", text: "😄 Excellent")
    end

    test "shows empty state when no entries exist", %{conn: conn} do
      conn
      |> visit(~p"/journal")
      |> assert_has("p", text: "No journal entries here yet")
    end

    test "creates new journal entry", %{conn: conn} do
      conn
      |> visit(~p"/journal")
      |> fill_in("Notes (optional)", with: @create_attrs.notes)
      |> choose("😄")
      |> click_button("Save Entry")
      |> assert_has("[data-qa='journal-entry']", text: @create_attrs.notes)
      |> assert_has("[data-qa='journal-entry']", text: "😄 Excellent")
    end

    test "creates journal entry with custom date", %{conn: conn} do
      conn
      |> visit(~p"/journal")
      |> click_button("Specify date")
      |> fill_in("When did this happen?", with: "2024-01-20")
      |> click_button("Save Entry")
      |> assert_has("[data-qa='journal-entry']", text: "2024", timeout: 2_000)
    end

    test "creates journal entry without notes", %{conn: conn} do
      conn
      |> visit(~p"/journal")
      |> choose("😐")
      |> click_button("Save Entry")
      |> assert_has("[data-qa=journal-entry]", text: "😐 Neutral")
    end

    test "deletes journal entry", %{conn: conn, user: user} do
      {:ok, journal_entry} = Journal.create_entry(user, @create_attrs)

      conn
      |> visit(~p"/journal")
      |> assert_has("[data-qa=journal-entry]")
      |> click_button("Delete entry")
      |> refute_has("[data-qa=journal-entry]")

      refute Repo.reload(journal_entry)
    end

    @tag :capture_log
    test "shows validation errors for invalid entry", %{conn: conn} do
      conn
      |> visit(~p"/journal")
      |> fill_in("When did this happen?", with: "3024-01-20")
      |> click_button("Save Entry")
      |> assert_has("p", text: "must be in the past")
    end

    test "mood rating selection works correctly", %{conn: conn} do
      session = visit(conn, ~p"/journal")

      for rating <- ["😢", "😕", "😐", "🙂", "😄"] do
        session
        |> choose(rating)
        |> click_button("Save Entry")
        |> assert_has("[data-qa=journal-entry]", text: rating)
      end
    end

    test "real-time updates when entry is created", %{conn: conn, user: user} do
      session = visit(conn, ~p"/journal")

      # Create entry through the context to simulate real-time update
      {:ok, entry} = Journal.create_entry(user, @create_attrs)

      # The entry should appear automatically via PubSub
      assert_has(session, "[data-qa=journal-entry]", text: entry.notes)
    end
  end
end
