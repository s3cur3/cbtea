defmodule Cbt.JournalTest do
  use Cbt.DataCase, async: true

  alias Cbt.Accounts
  alias Cbt.Journal
  alias Cbt.Journal.Entry

  setup do
    {:ok, user} =
      Accounts.register_user(%{
        email: "jdoe-#{System.unique_integer()}@example.com",
        password: "12345678"
      })

    %{user: user}
  end

  describe "journal entries" do
    test "create_entry/2 with valid data creates a journal entry", %{user: user} do
      attrs = %{notes: "Great day today!", mood_rating: 4, entry_date: ~N[2024-01-01 12:00:00]}

      assert {:ok, %Entry{} = entry} = Journal.create_entry(user, attrs)
      assert entry.notes == "Great day today!"
      assert entry.mood_rating == 4
      assert entry.entry_date == ~N[2024-01-01 12:00:00]
      assert entry.user_id == user.id
    end

    test "create_entry/2 with invalid mood rating returns error changeset", %{user: user} do
      for invalid <- [nil, -1, 5] do
        attrs = %{notes: "Bad day", mood_rating: invalid, entry_date: ~N[2024-01-01 12:00:00]}
        assert {:error, %Ecto.Changeset{}} = Journal.create_entry(user, attrs)
      end
    end

    test "create_entry/2 with future date returns error changeset", %{user: user} do
      future_date = NaiveDateTime.add(NaiveDateTime.utc_now(), 3600, :second)
      attrs = %{notes: "Future entry", mood_rating: 2, entry_date: future_date}
      assert {:error, %Ecto.Changeset{}} = Journal.create_entry(user, attrs)
    end

    test "create_entry/2 without required fields returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} =
               Journal.create_entry(user, %{notes: "Missing required fields"})
    end

    test "all_entries/1 returns all entries for user", %{user: user} do
      entry1 =
        Journal.create_entry(user, %{
          notes: "First entry",
          mood_rating: 2,
          entry_date: ~N[2024-01-01 12:00:00]
        })

      entry2 =
        Journal.create_entry(user, %{
          notes: "Second entry",
          mood_rating: 3,
          entry_date: ~N[2024-01-01 13:00:00]
        })

      assert {:ok, entry1} = entry1
      assert {:ok, entry2} = entry2

      entries = Journal.all_entries(user)
      assert length(entries) == 2
      assert entry1 in entries
      assert entry2 in entries
    end

    test "delete_entry/2 deletes the entry", %{user: user} do
      {:ok, entry} =
        Journal.create_entry(user, %{
          notes: "First entry",
          mood_rating: 2,
          entry_date: ~N[2024-01-01 12:00:00]
        })

      assert {:ok, %Entry{}} = Journal.delete_entry(entry, entry.user_id)
      assert Journal.all_entries(entry.user_id) == []
    end

    test "delete_entry/2 with wrong user returns error", %{user: user} do
      {:ok, entry} =
        Journal.create_entry(user, %{
          notes: "First entry",
          mood_rating: 2,
          entry_date: ~N[2024-01-01 12:00:00]
        })

      {:ok, other_user} =
        Accounts.register_user(%{
          email: "jdoe-#{System.unique_integer()}@example.com",
          password: "12345678"
        })

      assert {:error, "Insufficient permissions to delete entry"} =
               Journal.delete_entry(entry, other_user)
    end
  end
end
