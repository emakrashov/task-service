defmodule TaskServiceWeb.TaskController do
  use TaskServiceWeb, :controller
  alias TaskService.ChainBuilder

  def create(conn, %{"tasks" => tasks} = params) do
    ordered_tasks =
      tasks
      |> Enum.map(&TaskService.Task.new(&1))
      |> ChainBuilder.build()

    if params["format"] == "bash_script" do
      text(conn, format_as_script(ordered_tasks))
    else
      json(conn, %{
        "tasks" => ordered_tasks
      })
    end
  end

  defp format_as_script(ordered_tasks) do
    script =
      ordered_tasks
      |> Enum.map_join("\n", & &1.command)

    """
    #!/usr/bin/env bash
    #{script}
    """
  end
end
