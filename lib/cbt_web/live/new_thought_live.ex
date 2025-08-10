defmodule CbtWeb.NewThoughtLive do
  use CbtWeb, :live_component

  alias Cbt.Accounts.User
  alias Cbt.Thoughts
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
        id="new_thought_form"
        phx-submit="submit"
        phx-change="validate"
        phx-target={@myself}
        phx-hook="ScrollToAnchor"
      >
        <.input
          field={@form[:automatic_thought]}
          id="automatic-thought"
          autofocus
          type="errorless-text"
          label="Automatic thought"
          placeholder="What's going on?"
          class="peer"
        />

        <div class="space-y-8 peer-placeholder-shown:hidden">
          <div class="space-y-2">
            <.label for="cognitive-distortions">Cognitive distortion</.label>
            <div :for={distortion <- Cbt.Distortions.all_distortions()}>
              <.distortion_select field={@form[:distortions]} distortion={distortion} />
            </div>
          </div>

          <.input field={@form[:challenge]} type="text" label="Challenge" />

          <.input field={@form[:alternative_thought]} type="text" label="Alternative thought" />

          <div class="space-y-2">
            <.label for="thought-occurred-at">When did this thought occur?</.label>
            <div :if={not @show_datetime_input} class="flex items-center space-x-3">
              <div class="flex-1">
                <span class="text-sm text-zinc-600">Just now</span>
              </div>
              <button
                type="button"
                phx-click="show_datetime_input"
                phx-target={@myself}
                class="inline-flex items-center px-2 py-1 text-xs font-medium rounded bg-blue-100 text-blue-950 hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-400"
              >
                Specify time
              </button>
            </div>
            <div :if={@show_datetime_input} class="mt-2">
              <.input field={@form[:inserted_at]} id="thought-occurred-at" type="datetime-local" />
            </div>
          </div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving..." class="w-full">
            Save <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def handle_event("show_datetime_input", _params, socket) do
    {:noreply, assign(socket, show_datetime_input: true)}
  end

  def handle_event("validate", %{"thought" => params}, socket) do
    {:noreply, update_form(socket, params)}
  end

  def handle_event("submit", %{"thought" => thought_params}, socket) do
    user = current_user(socket)

    # Parse datetime string if present, otherwise use current time
    thought_params =
      case thought_params["inserted_at"] do
        nil ->
          # Set to current time when no custom time is specified
          Map.put(thought_params, "inserted_at", NaiveDateTime.utc_now())

        datetime_str when is_binary(datetime_str) and datetime_str != "" ->
          case DateTimeParser.parse(datetime_str) do
            {:ok, datetime} -> Map.put(thought_params, "inserted_at", datetime)
            _ -> Map.put(thought_params, "inserted_at", NaiveDateTime.utc_now())
          end

        _ ->
          Map.put(thought_params, "inserted_at", NaiveDateTime.utc_now())
      end

    case Thoughts.create_thought(user, thought_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> assign_new_form_changeset()
         |> scroll_to_id("past-thoughts")}

      {:error, changeset} ->
        Logger.error("Error creating thought: #{inspect(changeset)}")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp assign_new_form_changeset(socket) do
    user = current_user(socket)
    # Don't set a default inserted_at - let it be nil initially
    changeset = Thoughts.new_thought_changeset(user)
    form = to_form(changeset)
    assign(socket, form: form, show_datetime_input: false)
  end

  defp update_form(socket, attrs) do
    user = current_user(socket)

    # Parse datetime string if present
    attrs =
      case attrs["inserted_at"] || attrs[:inserted_at] do
        nil ->
          attrs

        datetime_str when is_binary(datetime_str) and datetime_str != "" ->
          case NaiveDateTime.from_iso8601(datetime_str) do
            {:ok, datetime} -> Map.put(attrs, "inserted_at", datetime)
            _ -> attrs
          end

        _ ->
          attrs
      end

    changeset =
      Thoughts.new_thought_changeset(user, attrs)
      |> Map.put(:action, :validate)

    assign(socket, form: to_form(changeset))
  end

  defp scroll_to_id(socket, element_id) do
    push_event(socket, "scrollTo", %{anchor: element_id})
  end

  def current_user(%{assigns: %{current_user: user}}), do: user
end
