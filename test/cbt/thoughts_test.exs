defmodule Cbt.ThoughtsTest do
  use Cbt.DataCase
  alias Cbt.Thoughts

  setup do
    {:ok, user} = Cbt.Accounts.register_user(%{email: "jdoe@example.com", password: "12345678"})
    %{user: user}
  end

  test "can create empty thoughts", %{user: user} do
    assert {:ok, thought} = Thoughts.create_thought(user)
    assert thought.automatic_thought == ""
    assert thought.cognitive_distortion == nil
    assert thought.challenge == ""
    assert thought.alternative_thought == ""
  end

  test "can create fully formed thoughts", %{user: user} do
    attrs = %{
      automatic_thought: "I'm a failure",
      cognitive_distortion: :all_or_nothing,
      challenge: "I'm not a failure",
      alternative_thought: "I can do this!"
    }

    assert {:ok, thought} = Thoughts.create_thought(user, attrs)
    assert thought.automatic_thought == attrs.automatic_thought
    assert thought.cognitive_distortion == attrs.cognitive_distortion
    assert thought.challenge == attrs.challenge
    assert thought.alternative_thought == attrs.alternative_thought
  end
end
