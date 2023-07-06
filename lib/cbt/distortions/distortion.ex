defmodule Cbt.Distortions.Distortion do
  use TypedStruct
  import UnionTypespec, only: [union_type: 1]

  @categories [
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

  union_type(category :: @categories)

  @spec categories() :: [category()]
  def categories, do: @categories

  typedstruct enforce: true do
    field :emoji, String.t()
    field :label, String.t()
    field :slug, category()
    field :description, String.t()
  end
end
