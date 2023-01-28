defmodule TaskService.ChainBuilderTest do
  use TaskServiceWeb.ConnCase
  alias TaskService.ChainBuilder

  @tasks [
           %{
             "name" => "task-1",
             "command" => "touch /tmp/file1"
           },
           %{
             "name" => "task-2",
             "command" => "cat /tmp/file1",
             "requires" => [
               "task-3"
             ]
           },
           %{
             "name" => "task-3",
             "command" => "echo 'Hello World!' > /tmp/file1",
             "requires" => [
               "task-1"
             ]
           },
           %{
             "name" => "task-4",
             "command" => "rm /tmp/file1",
             "requires" => [
               "task-2",
               "task-3"
             ]
           }
         ]
         |> Enum.map(&TaskService.Task.new(&1))

  test "builds a chain of tasks with the proper order" do
    assert ChainBuilder.build(@tasks) == [
             %{
               name: "task-1",
               command: "touch /tmp/file1"
             },
             %{
               name: "task-3",
               command: "echo 'Hello World!' > /tmp/file1"
             },
             %{
               name: "task-2",
               command: "cat /tmp/file1"
             },
             %{
               name: "task-4",
               command: "rm /tmp/file1"
             }
           ]
  end
end
