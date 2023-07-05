defmodule Cbt.Thoughts.Thought do
  use Ecto.Schema
  use TypedEctoSchema
  import Ecto.Changeset
  alias Cbt.Distortions

  typed_schema "thoughts" do
    field :automatic_thought, :string, null: false, default: ""
    field :cognitive_distortion, Ecto.Enum, values: Distortions.distortions()
    field :alternative_thought, :string, null: false, default: ""
    field :challenge, :string, null: false, default: ""

    belongs_to :user, Cbt.Accounts.User, null: false

    timestamps()
  end

  @doc false
  def insert_changeset(thought \\ %__MODULE__{}, user_id, attrs) do
    thought
    |> cast(attrs, [
      :automatic_thought,
      :cognitive_distortion,
      :challenge,
      :alternative_thought
    ])
    |> put_change(:user_id, user_id)
  end
end
