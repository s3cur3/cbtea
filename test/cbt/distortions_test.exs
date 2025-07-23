defmodule Cbt.DistortionsTest do
  use Cbt.DataCase, async: true

  alias Cbt.Distortions
  alias Cbt.Distortions.Distortion

  test "can create new distortions" do
    attrs = %{
      emoji: "🤯",
      label: "Catastrophizing",
      name: "catastrophizing-#{System.unique_integer()}}",
      description: "Focusing on the worst possible scenario"
    }

    assert {:ok, %Distortion{} = distortion} = Distortions.create_distortion(attrs)

    assert distortion.emoji == attrs.emoji
    assert distortion.label == attrs.label
    assert distortion.name == attrs.name
    assert distortion.description == attrs.description
  end

  test "can list all distortions, sorted alphabetically" do
    emotional_attrs = %{
      emoji: "🎭",
      label: "Emotional Reasoning",
      name: "emotional_reasoning-#{System.unique_integer()}",
      description: "Ex. “I feel afraid, so I'll have a panic attack”"
    }

    should_attrs = %{
      emoji: "✨",
      label: "Should Statements",
      name: "should_statements-#{System.unique_integer()}",
      description: "Ex. “I should have been better”"
    }

    labeling_attrs = %{
      emoji: "🏷",
      label: "Labeling",
      name: "labeling-#{System.unique_integer()}",
      description: "Ex. “He’s a jerk”"
    }

    sorted_attrs = [emotional_attrs, labeling_attrs, should_attrs]

    for distortion <- Enum.shuffle(sorted_attrs) do
      {:ok, _} = Distortions.create_distortion(distortion)
    end

    actual_distortions =
      Distortions.all_distortions()
      |> Enum.map(&Map.take(&1, [:emoji, :label, :name, :description]))

    assert actual_distortions == sorted_attrs
  end
end
