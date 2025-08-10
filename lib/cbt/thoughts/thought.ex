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
      :alternative_thought,
      :inserted_at
    ])
    |> put_change(:user_id, user_id)
    |> put_assoc(:distortions, parse_distortions(attrs))
    |> validate_date_not_in_the_future(:inserted_at)
  end

  defp parse_distortions(attrs) do
    names = attrs["distortions"] || attrs[:distortions] || []

    Utils.Enum.map_compact(names, &Cbt.Repo.get_by(Distortion, name: &1))
  end

  defp validate_date_not_in_the_future(changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset

      inserted_at ->
        if NaiveDateTime.after?(inserted_at, NaiveDateTime.utc_now()) do
          add_error(changeset, field, "must be in the past")
        else
          changeset
        end
    end
  end
end
