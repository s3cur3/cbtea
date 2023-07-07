defmodule Cbt.Repo.Migrations.AddDistortionsTable do
  use Ecto.Migration

  def change do
    alter table(:thoughts) do
      remove :cognitive_distortion
    end

    create table(:distortions) do
      add :name, :string
      add :label, :string
      add :emoji, :string
      add :description, :string

      timestamps()
    end

    create table(:thoughts_distortions, primary_key: false) do
      add :distortion_id, references(:distortions, on_delete: :delete_all), null: false
      add :thought_id, references(:thoughts, on_delete: :delete_all), null: false
    end

    create index(:thoughts, [:id])

    create index(:distortions, [:id])
    create unique_index(:distortions, [:name])

    create index(:thoughts_distortions, [:thought_id])
    create unique_index(:thoughts_distortions, [:thought_id, :distortion_id])
  end
end
