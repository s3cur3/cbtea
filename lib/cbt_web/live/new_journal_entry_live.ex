defmodule CbtWeb.NewJournalEntryLive do
  use CbtWeb, :live_component

  alias Cbt.Accounts.User
  alias Cbt.Journal
  alias NaiveDateTime

  require Logger

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new_form_changeset()}
  end

  attr :current_user, User, required: true

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md">
      <.simple_form
        for={@form}
        id="new_journal_entry_form"
        phx-submit="submit"
        phx-change="validate"
        phx-target={@myself}
        phx-hook="ScrollToAnchor"
      >
        <div class="space-y-2">
          <.label for="mood-rating">How are you feeling?</.label>
          <div class="flex items-center justify-between space-x-2">
            <div :for={rating <- 0..4} class="flex flex-col items-center">
              <input
                type="radio"
                name="entry[mood_rating]"
                value={rating}
                id={"mood-rating-#{rating}"}
                class="sr-only"
                checked={@form[:mood_rating].value == rating}
              />
              <label
                for={"mood-rating-#{rating}"}
                class={[
                  "cursor-pointer p-2 rounded-full transition-colors border-2",
                  if(@form[:mood_rating].value == rating,
                    do: "bg-blue-100 border-blue-500 ring-2 ring-blue-300 text-blue-900",
                    else: "hover:bg-gray-100 border-transparent"
                  )
                ]}
              >
                <span class="text-2xl">{mood_emoji(rating)}</span>
              </label>
              <span class={[
                "text-xs mt-1",
                if(@form[:mood_rating].value == rating, do: "text-blue-700 font-semibold", else: "text-gray-600")
              ]}>
                {mood_label(rating)}
              </span>
            </div>
          </div>
        </div>

        <.input
          field={@form[:notes]}
          type="textarea"
          label="Notes (optional)"
          placeholder="How was your day? What's on your mind?"
          rows={4}
        />

        <div class="space-y-2">
          <.label for="entry-date">When did this happen?</.label>
          <div :if={not @show_datetime_input} class="flex items-center space-x-3">
            <div class="flex-1">
              <span class="text-sm text-zinc-600">Today</span>
            </div>
            <button
              type="button"
              phx-click="show_datetime_input"
              phx-target={@myself}
              class="inline-flex items-center px-2 py-1 text-xs font-medium rounded bg-blue-100 text-blue-950 hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-400"
            >
              Specify date
            </button>
          </div>
          <div class={["mt-2", if(not @show_datetime_input, do: "hidden")]}>
            <.input field={@form[:inserted_at]} id="entry-date" type="date" />
          </div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving..." class="w-full">
            Save Entry <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
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

  @impl Phoenix.LiveComponent
  def handle_event("show_datetime_input", _params, socket) do
    {:noreply, assign(socket, show_datetime_input: true)}
  end

  def handle_event("validate", %{"entry" => params}, socket) do
    {:noreply, update_form(socket, params)}
  end

  def handle_event("submit", %{"entry" => entry_params}, socket) do
    user = current_user(socket)

    case Journal.create_entry(user, parse_inserted_at_date(entry_params)) do
      {:ok, _} ->
        {:noreply,
         socket
         |> assign_new_form_changeset()
         |> scroll_to_id("past-entries")}

      {:error, changeset} ->
        Logger.error("Error creating journal entry: #{inspect(changeset)}")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp assign_new_form_changeset(socket) do
    user = current_user(socket)
    # Set default mood rating to neutral (2) and current date
    default_attrs = %{
      "mood_rating" => 2,
      "inserted_at" => nil,
      "notes" => ""
    }

    changeset = Journal.new_entry_changeset(user, default_attrs)
    form = to_form(changeset)
    assign(socket, form: form, show_datetime_input: false)
  end

  defp update_form(socket, attrs) do
    user = current_user(socket)

    changeset =
      Journal.new_entry_changeset(user, parse_inserted_at_date(attrs))
      |> Map.put(:action, :validate)

    assign(socket, form: to_form(changeset))
  end

  defp scroll_to_id(socket, element_id) do
    push_event(socket, "scrollTo", %{anchor: element_id})
  end

  def current_user(%{assigns: %{current_user: user}}), do: user

  defp parse_inserted_at_date(params) do
    with inserted_at when byte_size(inserted_at) > 0 <- params["inserted_at"],
         {:ok, %Date{} = date} <- DateTimeParser.parse(inserted_at) do
      dt = NaiveDateTime.new!(date, ~T[00:00:00])
      Map.put(params, "inserted_at", dt)
    else
      _ -> Map.delete(params, "inserted_at")
    end
  end
end
