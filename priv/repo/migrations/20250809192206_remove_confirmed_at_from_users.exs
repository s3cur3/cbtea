defmodule Cbt.Repo.Migrations.RemoveConfirmedAtFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :confirmed_at
    end
  end
end
