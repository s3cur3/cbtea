defmodule Cbt.Thoughts do
  import Ecto.Query
  alias Cbt.Accounts.User
  alias Cbt.Thoughts.Thought
  alias Cbt.Repo

  @spec create_thought(User.t() | Repo.id(), map) ::
          {:ok, Thought.t()} | {:error, Ecto.Changeset.t()}
  def create_thought(user_or_id, attrs \\ %{}) do
    user_or_id
    |> new_thought_changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, thought} -> {:ok, preload_thought(thought)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec new_thought_changeset(User.t() | Repo.id(), map) :: Ecto.Changeset.t()
  def new_thought_changeset(user_or_id, attrs \\ %{}) do
    Thought.insert_changeset(Repo.id(user_or_id, User), attrs)
  end

  @spec all_thoughts(User.t() | Repo.id()) :: [Thought.t()]
  def all_thoughts(user_or_id) do
    user_id = Repo.id(user_or_id, User)

    from(t in Thought,
      where: t.user_id == ^user_id,
      order_by: [desc: :inserted_at],
      preload: :distortions
    )
    |> Repo.all()
  end

  defp preload_thought(thought, opts \\ []) do
    Repo.preload(thought, :distortions, opts)
  end
end
