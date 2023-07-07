defmodule Cbt.ThoughtsTest do
  use Cbt.DataCase, async: true
  alias Cbt.Thoughts
  alias Cbt.Thoughts.Thought

  setup do
    {:ok, user} = Cbt.Accounts.register_user(%{email: "jdoe@example.com", password: "12345678"})
    %{user: user}
  end

  test "can create empty thoughts", %{user: user} do
    assert {:ok, thought} = Thoughts.create_thought(user)
    assert thought.automatic_thought == ""
    assert thought.distortions == []
    assert thought.challenge == ""
    assert thought.alternative_thought == ""
  end

  test "can create fully formed thoughts", %{user: user} do
    Cbt.SeedHelpers.apply_seeds()

    attrs = %{
      automatic_thought: "I'm a failure",
      distortions: ["all_or_nothing", "overgeneralization"],
      challenge: "I'm not a failure",
      alternative_thought: "I can do this!"
    }

    assert {:ok, thought} = Thoughts.create_thought(user, attrs)
    assert thought.automatic_thought == attrs.automatic_thought
    assert thought.challenge == attrs.challenge
    assert thought.alternative_thought == attrs.alternative_thought

    assert length(thought.distortions) == 2
    assert Enum.any?(thought.distortions, &(&1.name == "all_or_nothing"))
    assert Enum.any?(thought.distortions, &(&1.name == "overgeneralization"))
  end

  test "can delete your own thoughts", %{user: user} do
    assert {:ok, thought} = Thoughts.create_thought(user)
    assert {:ok, _} = Thoughts.delete_thought(thought, user)
    assert Thoughts.all_thoughts(user) == []
  end

  test "can delete your own thought by ID", %{user: user} do
    assert {:ok, thought} = Thoughts.create_thought(user)
    assert {:ok, _} = Thoughts.delete_thought(thought.id, user.id)
    assert Thoughts.all_thoughts(user) == []
  end

  test "cannot delete others' thoughts", %{user: user} do
    assert {:ok, thought} = Thoughts.create_thought(user)
    assert {:error, msg} = Thoughts.delete_thought(thought, Ecto.UUID.generate())
    assert is_binary(msg)
  end

  test "can list all thoughts ordered by recency", %{user: user} do
    thoughts = [
      "This party is lame",
      "I'm a failure",
      "I don't eat green things"
    ]

    Enum.with_index(thoughts, fn thought, index ->
      {:ok, thought} = Thoughts.create_thought(user, %{automatic_thought: thought})
      fake_old_insertion_time(thought, index * 60)
    end)

    all_thoughts = Thoughts.all_thoughts(user)
    assert Enum.map(all_thoughts, & &1.automatic_thought) == thoughts
  end

  defp fake_old_insertion_time(thought, seconds_ago) do
    then = NaiveDateTime.utc_now() |> NaiveDateTime.add(-seconds_ago, :second)

    from(t in Thought, where: t.id == ^thought.id)
    |> Cbt.Repo.update_all(set: [inserted_at: then])
  end
end
