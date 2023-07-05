defmodule Cbt.Thoughts do
  alias Cbt.Accounts.User
  alias Cbt.Thoughts.Thought
  alias Cbt.Repo

  @spec create_thought(User.t() | Repo.id(), map) ::
          {:ok, Thought.t()} | {:error, Ecto.Changeset.t()}
  def create_thought(user, attrs \\ %{}) do
    Thought.insert_changeset(Repo.id(user, User), attrs)
    |> Repo.insert()
  end
end
