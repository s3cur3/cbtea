# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cbt.Repo.insert!(%Cbt.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Cbt.Accounts

distortions = [
  %{
    emoji: "🌓",
    label: "All or Nothing Thinking",
    name: "all_or_nothing",
    description: "Ex. “That was a thorough waste of time”"
  },
  %{
    emoji: "👯‍",
    label: "Overgeneralization",
    name: "overgeneralization",
    description: "Ex. “Everyone will let me down”"
  },
  %{
    emoji: "🧠",
    label: "Mindreading",
    name: "mind_reading",
    description: "Ex. “I'll bet he hates me now”"
  },
  %{
    emoji: "🔮",
    label: "Fortune Telling",
    name: "fortune_telling",
    description: "Ex. “I'll get sick at the party”"
  },
  %{
    emoji: "👎",
    label: "Magnification of the Negative",
    name: "magnification_of_the_negative",
    description: "Focusing only on what went wrong"
  },
  %{
    emoji: "👍",
    label: "Minimization of the Positive",
    name: "minimization_of_the_positive",
    description: "Ignoring the good things that happened"
  },
  %{
    emoji: "🤯",
    label: "Catastrophizing",
    name: "catastrophizing",
    description: "Focusing on the worst possible scenario"
  },
  %{
    emoji: "🎭",
    label: "Emotional Reasoning",
    name: "emotional_reasoning",
    description: "Ex. “I feel afraid, so I'll have a panic attack”"
  },
  %{
    emoji: "✨",
    label: "Should Statements",
    name: "should_statements",
    description: "Ex. “I should have been better”"
  },
  %{
    emoji: "🏷",
    label: "Labeling",
    name: "labeling",
    description: "Ex. “He’s a jerk”"
  },
  %{
    emoji: "👁",
    label: "Self-Blaming",
    name: "self_blaming",
    description: "Taking all the blame on yourself"
  },
  %{
    emoji: "🧛‍",
    label: "Other-Blaming",
    name: "other_blaming",
    description: "Assigning all the blame to someone else"
  }
]

known_distortion_names =
  Cbt.Distortions.all_distortions()
  |> MapSet.new(& &1.name)

for distortion <- distortions,
    not MapSet.member?(known_distortion_names, distortion.name) do
  {:ok, _} = Cbt.Distortions.create_distortion(distortion)
end

if !Accounts.get_user_by_email("tyler@tylerayoung.com") do
  {:ok, _} =
    Accounts.register_user(%{
      email: "tyler@tylerayoung.com",
      password: "test1234"
    })
end
