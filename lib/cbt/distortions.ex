defmodule Cbt.Distortions do
  import UnionTypespec, only: [union_type: 1]

  @distortions [
    :all_or_nothing,
    :overgeneralization,
    :mind_reading,
    :fortune_telling,
    :magnification_of_the_negative,
    :minimization_of_the_positive,
    :catastrophizing,
    :emotional_reasoning,
    :should_statements,
    :labeling,
    :self_blaming,
    :other_blaming
  ]

  union_type(distortion :: @distortions)
  def distortions, do: @distortions

  def all do
    [
      %{
        emoji: "🌓",
        label: "All or Nothing Thinking",
        slug: :all_or_nothing,
        description: "Ex. “That was a thorough waste of time”"
      },
      %{
        emoji: "👯‍",
        label: "Overgeneralization",
        slug: :overgeneralization,
        description: "Ex. “Everyone will let me down”"
      },
      %{
        emoji: "🧠",
        label: "Mindreading",
        slug: :mind_reading,
        description: "Ex. “I'll bet he hates me now”"
      },
      %{
        emoji: "🔮",
        label: "Fortune Telling",
        slug: :fortune_telling,
        description: "Ex. “I'll get sick at the party”"
      },
      %{
        emoji: "👎",
        label: "Magnification of the Negative",
        slug: :magnification_of_the_negative,
        description: "Focusing only on what went wrong"
      },
      %{
        emoji: "👍",
        label: "Minimization of the Positive",
        slug: :minimization_of_the_positive,
        description: "Ignoring the good things that happened"
      },
      %{
        emoji: "🤯",
        label: "Catastrophizing",
        slug: :catastrophizing,
        description: "Focusing on the worst possible scenario"
      },
      %{
        emoji: "🎭",
        label: "Emotional Reasoning",
        slug: :emotional_reasoning,
        description: "Ex. “I feel afraid, so I'll have a panic attack”"
      },
      %{
        emoji: "✨",
        label: "Should Statements",
        slug: :should_statements,
        description: "Ex. “I should have been better”"
      },
      %{
        emoji: "🏷",
        label: "Labeling",
        slug: :labeling,
        description: "Ex. “He’s a jerk”"
      },
      %{
        emoji: "👁",
        label: "Self-Blaming",
        slug: :self_blaming,
        description: "Taking all the blame on yourself"
      },
      %{
        emoji: "🧛‍",
        label: "Other-Blaming",
        slug: :other_blaming,
        description: "Assigning all the blame to someone else"
      }
    ]
  end
end
