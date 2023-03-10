defmodule TaskService.ChainBuilder.ReferenceError do
  defexception [:message]

  @impl true
  def exception({task, required_task_name}) do
    message = """
    The task "#{task.name}" requires "#{required_task_name}" but it doesn't exist.
    """

    %TaskService.ChainBuilder.ReferenceError{message: message}
  end
end

defimpl Plug.Exception, for: TaskService.ChainBuilder.ReferenceError do
  def status(_exception), do: 400
  def actions(_exception), do: []
end

defimpl Plug.Exception, for: Ecto.InvalidChangesetError do
  def status(_exception), do: 422
  def actions(_exception), do: []
end
