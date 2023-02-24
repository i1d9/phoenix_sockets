defmodule TodoWeb.IssueLive.Index do
  use TodoWeb, :live_view

  alias Todo.Task
  alias Todo.Task.Issue

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :issues, list_issues())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Issue")
    |> assign(:issue, Task.get_issue!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Issue")
    |> assign(:issue, %Issue{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Issues")
    |> assign(:issue, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    issue = Task.get_issue!(id)
    {:ok, _} = Task.delete_issue(issue)

    {:noreply, assign(socket, :issues, list_issues())}
  end

  defp list_issues do
    Task.list_issues()
  end
end
