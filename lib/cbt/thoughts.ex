defmodule Cbt.Thoughts do
  alias Cbt.Accounts.User
  alias Cbt.Thoughts.Thought
  alias Cbt.Repo

  @spec create_thought(User.t() | Repo.id(), map) ::
          {:ok, Thought.t()} | {:error, Ecto.Changeset.t()}
  def create_thought(user_or_id, attrs \\ %{}) do
    user_or_id
    |> new_thought_changeset(attrs)
    |> Repo.insert()
  end

  @spec create_thought(User.t() | Repo.id(), map) :: Ecto.Changeset.t()
  def new_thought_changeset(user_or_id, attrs \\ %{}) do
    Thought.insert_changeset(Repo.id(user_or_id, User), attrs)
  end
end
