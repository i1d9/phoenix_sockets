defmodule TodoWeb.IssueLive.Show do
  use TodoWeb, :live_view

  alias Todo.Task

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:issue, Task.get_issue!(id))}
  end

  defp page_title(:show), do: "Show Issue"
  defp page_title(:edit), do: "Edit Issue"
end
