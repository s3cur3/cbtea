defmodule Cbt.Distortions do
  alias Cbt.Distortions.Distortion
  alias Cbt.Repo

  @spec create_distortion(map) :: {:ok, Distortion.t()} | {:error, Ecto.Changeset.t()}
  def create_distortion(attrs) do
    %Distortion{}
    |> Distortion.insert_changeset(attrs)
    |> Repo.insert()
  end

  @spec all_distortions() :: [Distortion.t()]
  def all_distortions do
    Repo.all(Distortion)
    |> Enum.sort_by(& &1.label)
  end
end
