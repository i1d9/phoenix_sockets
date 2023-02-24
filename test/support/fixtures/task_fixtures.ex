defmodule Todo.TaskFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Task` context.
  """

  @doc """
  Generate a issue.
  """
  def issue_fixture(attrs \\ %{}) do
    {:ok, issue} =
      attrs
      |> Enum.into(%{
        completed: true,
        name: "some name"
      })
      |> Todo.Task.create_issue()

    issue
  end
end
