defmodule Cbt.Distortions do
  alias Cbt.Distortions.Distortion

  @spec all() :: [Distortion.t()]
  def all do
    [
      %Distortion{
        emoji: "🌓",
        label: "All or Nothing Thinking",
        slug: :all_or_nothing,
        description: "Ex. “That was a thorough waste of time”"
      },
      %Distortion{
        emoji: "👯‍",
        label: "Overgeneralization",
        slug: :overgeneralization,
        description: "Ex. “Everyone will let me down”"
      },
      %Distortion{
        emoji: "🧠",
        label: "Mindreading",
        slug: :mind_reading,
        description: "Ex. “I'll bet he hates me now”"
      },
      %Distortion{
        emoji: "🔮",
        label: "Fortune Telling",
        slug: :fortune_telling,
        description: "Ex. “I'll get sick at the party”"
      },
      %Distortion{
        emoji: "👎",
        label: "Magnification of the Negative",
        slug: :magnification_of_the_negative,
        description: "Focusing only on what went wrong"
      },
      %Distortion{
        emoji: "👍",
        label: "Minimization of the Positive",
        slug: :minimization_of_the_positive,
        description: "Ignoring the good things that happened"
      },
      %Distortion{
        emoji: "🤯",
        label: "Catastrophizing",
        slug: :catastrophizing,
        description: "Focusing on the worst possible scenario"
      },
      %Distortion{
        emoji: "🎭",
        label: "Emotional Reasoning",
        slug: :emotional_reasoning,
        description: "Ex. “I feel afraid, so I'll have a panic attack”"
      },
      %Distortion{
        emoji: "✨",
        label: "Should Statements",
        slug: :should_statements,
        description: "Ex. “I should have been better”"
      },
      %Distortion{
        emoji: "🏷",
        label: "Labeling",
        slug: :labeling,
        description: "Ex. “He’s a jerk”"
      },
      %Distortion{
        emoji: "👁",
        label: "Self-Blaming",
        slug: :self_blaming,
        description: "Taking all the blame on yourself"
      },
      %Distortion{
        emoji: "🧛‍",
        label: "Other-Blaming",
        slug: :other_blaming,
        description: "Assigning all the blame to someone else"
      }
    ]
  end
end
