defmodule Cbt.Journal do
  import Ecto.Query

  alias Cbt.Accounts.User
  alias Cbt.Journal.Entry
  alias Cbt.Repo

  @spec create_entry(User.t() | Repo.id(), map) ::
          {:ok, Entry.t()} | {:error, Ecto.Changeset.t()}
  def create_entry(user_or_id, attrs \\ %{}) do
    user_or_id
    |> new_entry_changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, entry} ->
        CbtWeb.PubSub.broadcast_journal_entry(entry)
        {:ok, entry}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec new_entry_changeset(User.t() | Repo.id(), map) :: Ecto.Changeset.t()
  def new_entry_changeset(user_or_id, attrs \\ %{}) do
    Entry.insert_changeset(Repo.id(user_or_id, User), attrs)
  end

  @spec delete_entry(Entry.t() | Repo.id(), User.t() | Repo.id()) ::
          {:ok, Entry.t()} | {:error, String.t() | Ecto.Changeset.t()}
  def delete_entry(entry_or_id, user_or_id)
  def delete_entry(entry_or_id, %User{} = user), do: delete_entry(entry_or_id, user.id)

  def delete_entry(%Entry{user_id: user_id} = entry, user_id) do
    case Repo.delete(entry) do
      {:ok, deleted_entry} ->
        CbtWeb.PubSub.broadcast_journal_entry_deletion(deleted_entry)
        {:ok, deleted_entry}

      error ->
        error
    end
  end

  def delete_entry(id, user) when is_integer(id) do
    get_entry(id)
    |> delete_entry(user)
  end

  def delete_entry(_entry, _user) do
    {:error, "Insufficient permissions to delete entry"}
  end

  @spec all_entries(User.t() | Repo.id()) :: [Entry.t()]
  def all_entries(user_or_id) do
    user_id = Repo.id(user_or_id, User)

    from(e in Entry,
      where: e.user_id == ^user_id,
      order_by: [desc: :inserted_at]
    )
    |> Repo.all()
  end

  defp get_entry(id), do: Repo.get!(Entry, id)
end
