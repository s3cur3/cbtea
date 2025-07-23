defmodule CbtWeb.NewThoughtLive do
  use CbtWeb, :live_component

  alias Cbt.Accounts.User
  alias Cbt.Thoughts

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
        phx-submit="save"
        phx-change="validate"
        phx-target={@myself}
        phx-hook="ScrollToAnchor"
      >
        <.input
          field={@form[:automatic_thought]}
          type="errorless-text"
          label="Automatic Thought"
          placeholder="What’s going on?"
          class="peer"
        />

        <div class="space-y-8 peer-placeholder-shown:hidden">
          <div class="space-y-2">
            <.label for="cognitive-distortions">Cognitive Distortion</.label>
            <div :for={distortion <- Cbt.Distortions.all_distortions()}>
              <.distortion_select field={@form[:distortions]} distortion={distortion} />
            </div>
          </div>

          <.input field={@form[:challenge]} type="text" label="Challenge" />
          <.input field={@form[:alternative_thought]} type="text" label="Alternative Thought" />
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
  def handle_event("validate", %{"thought" => params}, socket) do
    {:noreply, update_form(socket, params)}
  end

  def handle_event("save", %{"thought" => thought_params}, socket) do
    user = current_user(socket)

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
    changeset = Thoughts.new_thought_changeset(user)
    form = to_form(changeset)
    assign(socket, form: form)
  end

  defp update_form(socket, attrs) do
    user = current_user(socket)

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
