defmodule TaskService.ChainBuilder do
  @moduledoc """
  Builds a chain of tasks with the satisfied order requirements.
  """

  alias TaskService.ChainBuilder

  defstruct [
    :chain,
    :resolved_tasks,
    :task_index
  ]

  defp mark_as_resolved(task, chain_builder) do
    if MapSet.member?(chain_builder.resolved_tasks, task.name) do
      chain_builder
    else
      Map.merge(chain_builder, %{
        chain: chain_builder.chain ++ [task],
        resolved_tasks: MapSet.put(chain_builder.resolved_tasks, task.name)
      })
    end
  end

  defp resolve(task, chain_builder) do
    updated_chain_builder =
      task.requires
      |> Enum.reduce(chain_builder, fn (task_name, acc) ->
        if required_task = Map.get(chain_builder.task_index, task_name) do
          updated_chain_builder = resolve(required_task, acc)
          mark_as_resolved(required_task, updated_chain_builder)
        else
          raise TaskService.ChainBuilder.ReferenceError, {task, task_name}
        end
      end)

    task = Map.get(chain_builder.task_index, task.name)
    mark_as_resolved(task, updated_chain_builder)
  end

  defp build_task_index(tasks) do
    Enum.reduce(tasks, %{}, fn (task, acc) ->
      Map.put(acc, task.name, task)
    end)
  end

  @doc """
  Takes a list of tasks with the specified order requirements and returns a new ordered list.
  """
  def build(tasks) do
    chain_builder = %ChainBuilder{
      chain: [],
      resolved_tasks: MapSet.new(),
      task_index: build_task_index(tasks)
    }

    tasks
    |> Enum.reduce(chain_builder, fn (task, acc) ->
      resolve(task, acc)
    end)
    |> Map.get(:chain)
    |> Enum.map(fn (task) ->
      %{ name: task.name, command: task.command}
    end)
  end
end
