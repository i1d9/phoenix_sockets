defmodule TodoWeb.IssueLive.FormComponent do
  use TodoWeb, :live_component

  alias Todo.Task
  alias Phoenix.PubSub

  @impl true
  def update(%{issue: issue} = assigns, socket) do
    PubSub.subscribe(Todo.PubSub, "new_issue")
    changeset = Task.change_issue(issue)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"issue" => issue_params}, socket) do
    PubSub.broadcast(Todo.PubSub, "new_issue", {:typing, issue_params})

    changeset =
      socket.assigns.issue
      |> Task.change_issue(issue_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"issue" => issue_params}, socket) do
    save_issue(socket, socket.assigns.action, issue_params)
  end

  defp save_issue(socket, :edit, issue_params) do
    case Task.update_issue(socket.assigns.issue, issue_params) do
      {:ok, _issue} ->
        {:noreply,
         socket
         |> put_flash(:info, "Issue updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_issue(socket, :new, issue_params) do
    case Task.create_issue(issue_params) do
      {:ok, issue} ->
        PubSub.broadcast(
          Todo.PubSub,
          "new_issue",
          {:new_issue_created, issue |> Map.take([:id, :name, :completed])}
        )

        {:noreply,
         socket
         |> put_flash(:info, "Issue created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
