defmodule Todo.TaskTest do
  use Todo.DataCase

  alias Todo.Task

  describe "issues" do
    alias Todo.Task.Issue

    import Todo.TaskFixtures

    @invalid_attrs %{completed: nil, name: nil}

    test "list_issues/0 returns all issues" do
      issue = issue_fixture()
      assert Task.list_issues() == [issue]
    end

    test "get_issue!/1 returns the issue with given id" do
      issue = issue_fixture()
      assert Task.get_issue!(issue.id) == issue
    end

    test "create_issue/1 with valid data creates a issue" do
      valid_attrs = %{completed: true, name: "some name"}

      assert {:ok, %Issue{} = issue} = Task.create_issue(valid_attrs)
      assert issue.completed == true
      assert issue.name == "some name"
    end

    test "create_issue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_issue(@invalid_attrs)
    end

    test "update_issue/2 with valid data updates the issue" do
      issue = issue_fixture()
      update_attrs = %{completed: false, name: "some updated name"}

      assert {:ok, %Issue{} = issue} = Task.update_issue(issue, update_attrs)
      assert issue.completed == false
      assert issue.name == "some updated name"
    end

    test "update_issue/2 with invalid data returns error changeset" do
      issue = issue_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_issue(issue, @invalid_attrs)
      assert issue == Task.get_issue!(issue.id)
    end

    test "delete_issue/1 deletes the issue" do
      issue = issue_fixture()
      assert {:ok, %Issue{}} = Task.delete_issue(issue)
      assert_raise Ecto.NoResultsError, fn -> Task.get_issue!(issue.id) end
    end

    test "change_issue/1 returns a issue changeset" do
      issue = issue_fixture()
      assert %Ecto.Changeset{} = Task.change_issue(issue)
    end
  end
end
