defmodule TaskService.Task do
  alias TaskService.Task

  defstruct [
    :name,
    :command,
    :requires
  ]

  def new(attrs) do
    %Task{
      name: attrs["name"],
      command: attrs["command"],
      requires: Map.get(attrs, "requires", [])
    }
  end
end
