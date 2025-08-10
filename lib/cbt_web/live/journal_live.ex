defmodule CbtWeb.JournalLive do
  use CbtWeb, :live_view

  alias Cbt.I18n
  alias Cbt.Journal
  alias Cbt.Journal.Entry

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md">
      <.live_component module={CbtWeb.NewJournalEntryLive} id="new-journal-entry-form" current_user={@current_user} />

      <h2 class="text-base font-bold leading-6 text-zinc-800 mt-16 mb-4 md:mb-8 scroll-mt-20" id="past-entries">
        Past Entries
      </h2>
      <div id="journal-entries" phx-update="stream" class="space-y-12 peer">
        <.journal_entries streams={@streams} i18n={@i18n} />
      </div>
      <div class="hidden peer-empty:block text-zinc-500 text-center rounded border py-4">
        <p>No journal entries here yet.</p>
        <p>Log one above! 😄</p>
      </div>
    </div>
    """
  end

  defp journal_entries(assigns) do
    ~H"""
    <div :for={{dom_id, %Entry{} = entry} <- @streams.journal_entries} id={dom_id}>
      <.journal_entry entry={entry} i18n={@i18n} />
    </div>
    """
  end

  attr :entry, Entry, required: true
  attr :i18n, I18n, required: true

  def journal_entry(assigns) do
    ~H"""
    <article class="border rounded p-4 mb-4" data-qa="journal-entry">
      <button
        class="float-right text-zinc-300 rounded focus:text-red-800 focus:outline-none focus:ring focus:ring-red-300"
        phx-click="delete_entry"
        phx-value-entry_id={@entry.id}
      >
        <label class="sr-only" for="delete-entry-button">Delete entry</label>
        <.icon name="hero-trash" class="hover:text-red-800 active:text-red-800" />
      </button>

      <div class="flex items-center justify-between mb-2">
        <div class="text-sm text-zinc-600">
          {I18n.format_datetime(@i18n, @entry.inserted_at)}
        </div>
        <div class="text-lg font-bold">
          {mood_emoji(@entry.mood_rating)} {mood_label(@entry.mood_rating)}
        </div>
      </div>

      <div :if={@entry.notes && @entry.notes != ""} class="mt-2 text-zinc-800">
        {@entry.notes}
      </div>
    </article>
    """
  end

  defp mood_emoji(0), do: "😢"
  defp mood_emoji(1), do: "😕"
  defp mood_emoji(2), do: "😐"
  defp mood_emoji(3), do: "🙂"
  defp mood_emoji(4), do: "😄"

  defp mood_label(0), do: "Very Low"
  defp mood_label(1), do: "Low"
  defp mood_label(2), do: "Neutral"
  defp mood_label(3), do: "Good"
  defp mood_label(4), do: "Excellent"

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    user = current_user(socket)
    CbtWeb.PubSub.subscribe_user_journal_entries(user)

    {:ok,
     socket
     |> assign(page_title: "Journal · CBTea · The Cognitive Behavioral Therapy App")
     |> assign_localization_params()
     |> stream(:journal_entries, Journal.all_entries(user))}
  end

  @impl Phoenix.LiveView
  def handle_event("delete_entry", %{"entry_id" => entry_id_str}, socket) do
    user = current_user(socket)
    {entry_id, ""} = Integer.parse(entry_id_str)

    case Journal.delete_entry(entry_id, user) do
      {:ok, _} -> {:noreply, socket}
      {:error, reason} when is_binary(reason) -> {:noreply, put_flash(socket, :error, reason)}
      {:error, _} -> {:noreply, put_flash(socket, :error, "Failed to delete entry")}
    end
  end

  @impl Phoenix.LiveView
  def handle_info({:new_journal_entry, entry}, socket) do
    {:noreply, stream_insert(socket, :journal_entries, entry, at: 0)}
  end

  def handle_info({:journal_entry_deleted, entry}, socket) do
    {:noreply, stream_delete(socket, :journal_entries, entry)}
  end

  def handle_info(message, socket) do
    require Logger

    Logger.debug("Ignoring unhandled message: #{inspect(message)}")
    {:noreply, socket}
  end

  def current_user(%{assigns: %{current_user: user}}), do: user

  defp assign_localization_params(socket) do
    # Note that the connect_params are only available during mount
    connect_params = get_connect_params(socket)

    assign(socket,
      i18n: %I18n{
        locale: connect_params["locale"] || "en",
        timezone: connect_params["timezone"] || "Etc/UTC",
        timezone_offset_mins: connect_params["timezone_offset_mins"] || 0
      }
    )
  end
end
