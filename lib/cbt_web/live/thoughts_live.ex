defmodule CbtWeb.ThoughtsLive do
  use CbtWeb, :live_view
  alias Cbt.Distortions.Distortion
  alias Cbt.I18n
  alias Cbt.Thoughts
  alias Cbt.Thoughts.Thought

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md">
      <.live_component module={CbtWeb.NewThoughtLive} id="new-thought-form" current_user={@current_user} />

      <h2 class="text-base font-bold leading-6 text-zinc-800 mt-16 mb-4 md:mb-8 scroll-mt-20" id="past-thoughts">
        Past Thoughts
      </h2>
      <div id="thoughts" phx-update="stream" class="space-y-12 peer"><.thoughts streams={@streams} i18n={@i18n} /></div>
      <div class="hidden peer-empty:block text-zinc-500 text-center rounded border py-4">
        <p>No thoughts here yet.</p>
        <p>Log one above! 😄</p>
      </div>
    </div>
    """
  end

  defp thoughts(assigns) do
    ~H"""
    <div :for={{dom_id, %Thought{} = thought} <- @streams.thoughts} id={dom_id}>
      <.thought thought={thought} i18n={@i18n} />
    </div>
    """
  end

  attr :thought, Thought, required: true
  attr :i18n, I18n, required: true

  def thought(assigns) do
    ~H"""
    <article class="border rounded p-4 mb-4">
      <button
        class="float-right text-zinc-300 rounded focus:text-red-800 focus:outline-none focus:ring focus:ring-red-300"
        phx-click="delete_thought"
        phx-value-thought_id={@thought.id}
      >
        <.icon name="hero-trash" class="hover:text-red-800 active:text-red-800" />
      </button>
      <div class="font-light font-xl italic border-l-2 border-brand pl-2">
        <%= @thought.automatic_thought %>
      </div>
      <div :if={@thought.challenge != ""} class="mt-2">
        <h3 class="font-bold text-zinc-800 inline">Challenge</h3>: <%= @thought.challenge %>
      </div>
      <div :if={@thought.alternative_thought != ""} class="mt-2">
        <h3 class="font-bold text-zinc-800 inline">Alternative Thought</h3>: <%= @thought.alternative_thought %>
      </div>
      <div :if={@thought.distortions != []} class="my-2">
        <span
          :for={%Distortion{} = distortion <- @thought.distortions}
          class="rounded border px-3 py-2 mr-2 my-1 text-sm inline-block"
        >
          <%= distortion.emoji %>&nbsp; <%= distortion.label %>
        </span>
      </div>
      <div class="mt-2 text-sm text-zinc-600">
        <%= I18n.format_datetime(@i18n, @thought.inserted_at) %>
      </div>
    </article>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    user = current_user(socket)
    CbtWeb.PubSub.subscribe_user_thoughts(user)

    {:ok,
     socket
     |> assign(page_title: "Thoughts · CBTea · The Cognitive Behavioral Therapy App")
     |> assign_localization_params()
     |> stream(:thoughts, Thoughts.all_thoughts(user))}
  end

  @impl Phoenix.LiveView
  def handle_event("delete_thought", %{"thought_id" => thought_id_str}, socket) do
    user = current_user(socket)
    {thought_id, ""} = Integer.parse(thought_id_str)

    case Thoughts.delete_thought(thought_id, user) do
      {:ok, _} -> {:noreply, socket}
      {:error, reason} when is_binary(reason) -> {:noreply, put_flash(socket, :error, reason)}
      {:error, _} -> {:noreply, put_flash(socket, :error, "Failed to delete thought")}
    end
  end

  @impl Phoenix.LiveView
  def handle_info({:new_thought_created, thought}, socket) do
    {:noreply, stream_insert(socket, :thoughts, thought, at: 0)}
  end

  def handle_info({:thought_deleted, thought}, socket) do
    {:noreply, stream_delete(socket, :thoughts, thought)}
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
