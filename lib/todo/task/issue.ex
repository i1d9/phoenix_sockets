defmodule Todo.Task.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issues" do
    field :completed, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:name, :completed])
    |> validate_required([:name, :completed])
  end
end
