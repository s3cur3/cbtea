defmodule Cbt.Repo.Migrations.CreateThoughts do
  use Ecto.Migration
  import EctoEnumMigration

  def change do
    create_type(:distortion, [
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
    ])

    create table(:thoughts) do
      add :automatic_thought, :text, null: false
      add :cognitive_distortion, :distortion
      add :challenge, :text, null: false
      add :alternative_thought, :text, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:thoughts, [:user_id])
  end
end
