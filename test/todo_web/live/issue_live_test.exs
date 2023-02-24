defmodule TodoWeb.IssueLiveTest do
  use TodoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Todo.TaskFixtures

  @create_attrs %{completed: true, name: "some name"}
  @update_attrs %{completed: false, name: "some updated name"}
  @invalid_attrs %{completed: false, name: nil}

  defp create_issue(_) do
    issue = issue_fixture()
    %{issue: issue}
  end

  describe "Index" do
    setup [:create_issue]

    test "lists all issues", %{conn: conn, issue: issue} do
      {:ok, _index_live, html} = live(conn, Routes.issue_index_path(conn, :index))

      assert html =~ "Listing Issues"
      assert html =~ issue.name
    end

    test "saves new issue", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.issue_index_path(conn, :index))

      assert index_live |> element("a", "New Issue") |> render_click() =~
               "New Issue"

      assert_patch(index_live, Routes.issue_index_path(conn, :new))

      assert index_live
             |> form("#issue-form", issue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#issue-form", issue: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.issue_index_path(conn, :index))

      assert html =~ "Issue created successfully"
      assert html =~ "some name"
    end

    test "updates issue in listing", %{conn: conn, issue: issue} do
      {:ok, index_live, _html} = live(conn, Routes.issue_index_path(conn, :index))

      assert index_live |> element("#issue-#{issue.id} a", "Edit") |> render_click() =~
               "Edit Issue"

      assert_patch(index_live, Routes.issue_index_path(conn, :edit, issue))

      assert index_live
             |> form("#issue-form", issue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#issue-form", issue: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.issue_index_path(conn, :index))

      assert html =~ "Issue updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes issue in listing", %{conn: conn, issue: issue} do
      {:ok, index_live, _html} = live(conn, Routes.issue_index_path(conn, :index))

      assert index_live |> element("#issue-#{issue.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#issue-#{issue.id}")
    end
  end

  describe "Show" do
    setup [:create_issue]

    test "displays issue", %{conn: conn, issue: issue} do
      {:ok, _show_live, html} = live(conn, Routes.issue_show_path(conn, :show, issue))

      assert html =~ "Show Issue"
      assert html =~ issue.name
    end

    test "updates issue within modal", %{conn: conn, issue: issue} do
      {:ok, show_live, _html} = live(conn, Routes.issue_show_path(conn, :show, issue))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Issue"

      assert_patch(show_live, Routes.issue_show_path(conn, :edit, issue))

      assert show_live
             |> form("#issue-form", issue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#issue-form", issue: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.issue_show_path(conn, :show, issue))

      assert html =~ "Issue updated successfully"
      assert html =~ "some updated name"
    end
  end
end
