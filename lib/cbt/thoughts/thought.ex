defmodule Cbt.Thoughts.Thought do
  use TypedEctoSchema

  import Ecto.Changeset

  alias Cbt.Accounts.User
  alias Cbt.Distortions.Distortion
  alias Cbt.Utils

  typed_schema "thoughts" do
    field :automatic_thought, :string, null: false, default: ""
    field :alternative_thought, :string, null: false, default: ""
    field :challenge, :string, null: false, default: ""

    many_to_many :distortions, Distortion,
      join_through: "thoughts_distortions",
      on_replace: :delete

    belongs_to :user, User, null: false

    timestamps()
  end

  @doc false
  def insert_changeset(thought \\ %__MODULE__{}, user_id, attrs) do
    thought
    |> cast(attrs, [
      :automatic_thought,
      :challenge,
      :alternative_thought
    ])
    |> put_change(:user_id, user_id)
    |> put_assoc(:distortions, parse_distortions(attrs))
  end

  defp parse_distortions(attrs) do
    names = attrs["distortions"] || attrs[:distortions] || []

    Utils.Enum.map_compact(names, &Cbt.Repo.get_by(Distortion, name: &1))
  end
end
