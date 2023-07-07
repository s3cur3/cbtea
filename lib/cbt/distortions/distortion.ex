defmodule Cbt.Distortions.Distortion do
  use Ecto.Schema
  use TypedEctoSchema
  import Ecto.Changeset

  typed_schema "distortions" do
    field :name, :string
    field :label, :string
    field :emoji, :string
    field :description, :string

    timestamps()
  end

  def insert_changeset(%__MODULE__{} = distortion, attrs) do
    distortion
    |> cast(attrs, [
      :name,
      :label,
      :emoji,
      :description
    ])
    |> validate_required([:name, :label, :emoji, :description])
  end
end
