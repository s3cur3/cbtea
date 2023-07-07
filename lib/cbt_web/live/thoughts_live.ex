defmodule CbtWeb.ThoughtsLive do
  use CbtWeb, :live_view
  alias Cbt.Distortions.Distortion
  alias Cbt.I18n
  alias Cbt.Thoughts
  alias Cbt.Thoughts.Thought

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md">
      <.live_component module={CbtWeb.NewThoughtLive} id="new-thought-form" current_user={@current_user} />

      <h2 class="text-base font-bold leading-6 text-zinc-800 mt-16 mb-8">Past Thoughts</h2>
      <div id="thoughts" phx-update="stream" class="space-y-12">
        <div :for={{dom_id, %Thought{} = thought} <- @streams.thoughts} id={dom_id}>
          <.thought thought={thought} i18n={@i18n} />
        </div>
      </div>
    </div>
    """
  end

  attr :thought, Thought, required: true
  attr :i18n, I18n, required: true

  def thought(assigns) do
    ~H"""
    <article class="border rounded p-4">
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

  def mount(_params, _session, socket) do
    user = current_user(socket)
    CbtWeb.PubSub.subscribe_user_thoughts(user)

    {:ok,
     socket
     |> assign_localization_params()
     |> stream(:thoughts, Thoughts.all_thoughts(user))}
  end

  def handle_info({:new_thought_created, thought}, socket) do
    {:noreply, stream_insert(socket, :thoughts, thought, at: 0)}
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
