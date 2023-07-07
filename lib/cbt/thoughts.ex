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
      {:ok, thought} ->
        thought = preload_thought(thought)
        CbtWeb.PubSub.broadcast_user_thought(thought)
        {:ok, thought}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec new_thought_changeset(User.t() | Repo.id(), map) :: Ecto.Changeset.t()
  def new_thought_changeset(user_or_id, attrs \\ %{}) do
    Thought.insert_changeset(Repo.id(user_or_id, User), attrs)
  end

  @spec delete_thought(Thought.t() | Repo.id(), User.t() | Repo.id()) ::
          {:ok, Thought.t()} | {:error, String.t() | Ecto.Changeset.t()}
  def delete_thought(thought_or_id, user_or_id)
  def delete_thought(thought_or_id, %User{} = user), do: delete_thought(thought_or_id, user.id)

  def delete_thought(%Thought{user_id: user_id} = thought, user_id) do
    thought
    |> Repo.delete()
    |> tap(fn
      {:ok, thought} -> CbtWeb.PubSub.broadcast_user_thought_deletion(thought)
      _ -> :ok
    end)
  end

  def delete_thought(id, user) when is_integer(id) do
    get_thought(id)
    |> delete_thought(user)
  end

  def delete_thought(_thought, _user) do
    {:error, "Insufficient permissions to delete thought"}
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

  defp get_thought(id), do: Repo.get!(Thought, id)

  defp preload_thought(thought, opts \\ []) do
    Repo.preload(thought, :distortions, opts)
  end
end
