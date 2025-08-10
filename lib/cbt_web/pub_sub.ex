defmodule CbtWeb.PubSub do
  alias Cbt.Accounts.User
  alias Cbt.Journal.Entry
  alias Cbt.Repo
  alias Cbt.Thoughts.Thought

  @pubsub_name Cbt.PubSub

  @spec subscribe_user_thoughts(User.t() | Repo.id()) :: any()
  def subscribe_user_thoughts(user_or_id) do
    topic = user_topic(user_or_id)
    Phoenix.PubSub.subscribe(@pubsub_name, topic)
  end

  @spec subscribe_user_journal_entries(User.t() | Repo.id()) :: any()
  def subscribe_user_journal_entries(user_or_id) do
    topic = user_topic(user_or_id)
    Phoenix.PubSub.subscribe(@pubsub_name, topic)
  end

  @spec broadcast_user_thought(Thought.t()) :: any()
  def broadcast_user_thought(thought) do
    Phoenix.PubSub.broadcast(
      @pubsub_name,
      user_topic(thought.user_id),
      {:new_thought_created, thought}
    )
  end

  @spec broadcast_journal_entry(Entry.t()) :: any()
  def broadcast_journal_entry(entry) do
    Phoenix.PubSub.broadcast(
      @pubsub_name,
      user_topic(entry.user_id),
      {:new_journal_entry, entry}
    )
  end

  @spec broadcast_user_thought_deletion(Thought.t()) :: any()
  def broadcast_user_thought_deletion(thought) do
    Phoenix.PubSub.broadcast(
      @pubsub_name,
      user_topic(thought.user_id),
      {:thought_deleted, thought}
    )
  end

  @spec broadcast_journal_entry_deletion(Entry.t()) :: any()
  def broadcast_journal_entry_deletion(entry) do
    Phoenix.PubSub.broadcast(
      @pubsub_name,
      user_topic(entry.user_id),
      {:journal_entry_deleted, entry}
    )
  end

  @spec user_topic(User.t() | Repo.id()) :: String.t()
  def user_topic(user_or_id) do
    id = Cbt.Repo.id(user_or_id, User)
    "user:#{id}"
  end
end
