defmodule Cbt.Journal.Entry do
  use TypedEctoSchema

  import Ecto.Changeset

  alias Cbt.Accounts.User

  typed_schema "journal_entries" do
    field :notes, :string
    field :mood_rating, :integer, null: false
    field :entry_date, :naive_datetime, null: false
    belongs_to :user, User, null: false

    timestamps()
  end

  @doc false
  def insert_changeset(entry \\ %__MODULE__{}, user_id, attrs) do
    entry
    |> cast(attrs, [:notes, :mood_rating, :entry_date])
    |> put_change(:user_id, user_id)
    |> validate_mood_rating()
    |> Util.Ecto.validate_date_not_in_the_future(:entry_date)
    |> validate_required([:mood_rating, :entry_date])
  end

  defp validate_mood_rating(changeset) do
    validate_inclusion(changeset, :mood_rating, 0..4)
  end
end
