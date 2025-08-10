defmodule Cbt.Repo.Migrations.CreateJournalEntries do
  use Ecto.Migration

  def change do
    create table(:journal_entries) do
      add :notes, :text
      add :mood_rating, :integer, null: false
      add :entry_date, :naive_datetime, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:journal_entries, [:user_id])
    create index(:journal_entries, [:entry_date])
  end
end
