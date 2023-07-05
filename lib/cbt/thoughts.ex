defmodule Cbt.Thoughts do
  alias Cbt.Distortions

  def newThought do
    %{
      automatic_thought: "",
      cognitive_distortions:
        Enum.map(Distortions.all(), fn %{label: label, slug: slug} ->
          %{label: label, slug: slug, selected: false, description: ""}
        end),
      challenge: "",
      alternative_thought: ""
    }
  end
end
