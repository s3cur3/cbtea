defmodule CbtWeb.ThoughtsLive do
  use CbtWeb, :live_view
  alias Cbt.Thoughts
  alias Cbt.Thoughts.Thought

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.live_component module={CbtWeb.NewThoughtLive} id="new-thought-form" current_user={@current_user} />

      <h2 class="text-base font-bold leading-6 text-zinc-800 mt-16 mb-8">Past Thoughts</h2>
      <div id="thoughts" phx-update="stream" class="space-y-8">
        <div :for={{dom_id, %Thought{} = thought} <- @streams.thoughts} id={dom_id}>
          <%= thought.automatic_thought %>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = current_user(socket)
    CbtWeb.PubSub.subscribe_user_thoughts(user)

    {:ok, stream(socket, :thoughts, Thoughts.all_thoughts(user))}
  end

  def handle_info({:new_thought_created, thought}, socket) do
    {:noreply, stream_insert(socket, :thoughts, thought, at: 0)}
  end

  def current_user(%{assigns: %{current_user: user}}), do: user
end
