defmodule TodoWeb.RoomChannel do
  use TodoWeb, :channel
  alias Phoenix.PubSub
  @impl true
  def join("room:lobby", payload, socket) do
    # Process.send_after(self(), :update, 5000)
    PubSub.subscribe(Todo.PubSub, "new_issue")

    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:typing, payload}, socket) do
    broadcast(socket, "typing", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_issue_created, issue}, socket) do
    IO.inspect(issue)
    broadcast(socket, "new_issues", issue)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
