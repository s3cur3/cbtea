defmodule Cbt.Journal.Entry do
  use TypedEctoSchema

  import Ecto.Changeset

  alias Cbt.Accounts.User

  typed_schema "journal_entries" do
    field :notes, :string
    field :mood_rating, :integer, null: false
    belongs_to :user, User, null: false

    timestamps()
  end

  @doc false
  def insert_changeset(entry \\ %__MODULE__{}, user_id, attrs) do
    entry
    |> cast(attrs, [:notes, :mood_rating, :inserted_at])
    |> put_change(:user_id, user_id)
    |> validate_mood_rating()
    |> Util.Ecto.validate_date_not_in_the_future(:inserted_at)
    |> validate_required([:mood_rating])
  end

  defp validate_mood_rating(changeset) do
    validate_inclusion(changeset, :mood_rating, 0..4)
  end
end
