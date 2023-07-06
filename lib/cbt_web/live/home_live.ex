defmodule CbtWeb.HomeLive do
  use CbtWeb, :live_view
  alias Cbt.Thoughts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.live_component module={CbtWeb.NewThoughtLive} id="new-thought-form" current_user={@current_user} />

      <div>List here</div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = current_user(socket)
    CbtWeb.PubSub.subscribe_user_thoughts(user)

    {:ok, socket}
  end

  def handle_info({:new_thought_created, thought}, socket) do
    IO.inspect(thought, label: "thought")
    {:noreply, socket}
  end

  def current_user(%{assigns: %{current_user: user}}), do: user
end
