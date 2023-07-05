defmodule Cbt.Distortions do
  def all do
    [
      %{
        emoji: "🌓",
        label: "All or Nothing Thinking",
        slug: "all-or-nothing",
        description: "Ex. “That was a thorough waste of time”"
      },
      %{
        emoji: "👯‍",
        label: "Overgeneralization",
        slug: "overgeneralization",
        description: "Ex. “Everyone will let me down”"
      },
      %{
        emoji: "🧠",
        label: "Mindreading",
        slug: "mind-reading",
        description: "Ex. “I'll bet he hates me now”"
      },
      %{
        emoji: "🔮",
        label: "Fortune Telling",
        slug: "fortune-telling",
        description: "Ex. “I'll get sick at the party”"
      },
      %{
        emoji: "👎",
        label: "Magnification of the Negative",
        slug: "magnification-of-the-negative",
        description: "Focusing only on what went wrong"
      },
      %{
        emoji: "👍",
        label: i18n.t("minimization_of_the_positive"),
        slug: "minimization-of-the-positive",
        description: "Ignoring the good things that happened"
      },
      %{
        emoji: "💥",
        label: "Catastrophizing",
        slug: "catastrophizing",
        description: "Focusing on the worst possible scenario"
      },
      %{
        emoji: "🎭",
        label: "Emotional Reasoning",
        slug: "emotional-reasoning",
        description: "Ex. “I feel afraid, so I'll have a panic attack”"
      },
      %{
        emoji: "✨",
        label: "Should Statements",
        slug: "should-statements",
        description: "Ex. “I should have been better”"
      },
      %{
        emoji: "🏷",
        label: "Labeling",
        slug: "labeling",
        description: "Ex. “He’s a jerk”"
      },
      %{
        emoji: "👁",
        label: "Self-Blaming",
        slug: "self-blaming",
        description: "Taking all the blame on yourself"
      },
      %{
        emoji: "🧛‍",
        label: "Other-Blaming",
        slug: "other-blaming",
        description: "Assigning all the blame to someone else"
      }
    ]
  end
end
