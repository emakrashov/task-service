defmodule TaskService.Task do
  import Ecto.Changeset
  alias TaskService.Task

  defstruct [
    :name,
    :command,
    :requires
  ]

  @types %{
    name: :string,
    command: :string,
    requires: {:array, :string}
  }

  def new(attrs) do
    {%Task{}, @types}
    |> change(%{requires: []})
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:name, :command])
    |> apply_action!(:create)
  end
end
