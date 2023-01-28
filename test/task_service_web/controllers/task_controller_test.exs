defmodule TaskServiceWeb.TaskControllerTest do
  use TaskServiceWeb.ConnCase

  describe "POST /api/tasks" do
    test "when the list of tasks is empty", %{conn: conn} do
      conn =
        post(conn, ~p"/api/tasks", %{
          "tasks" => []
        })

      assert json_response(conn, 200) == %{"tasks" => []}
    end

    test "returns an ordered list of tasks", %{conn: conn} do
      conn =
        post(conn, ~p"/api/tasks", %{
          "tasks" => [
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
        })

      assert json_response(conn, 200) == %{
               "tasks" => [
                 %{"command" => "touch /tmp/file1", "name" => "task-1"},
                 %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3"},
                 %{"command" => "cat /tmp/file1", "name" => "task-2"},
                 %{"command" => "rm /tmp/file1", "name" => "task-4"}
               ]
             }
    end

    test "returns an ordered list of tasks regardless of the initial order", %{conn: conn} do
      tasks = [
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
        },
        %{
          "name" => "task-1",
          "command" => "touch /tmp/file1"
        }
      ]

      tasks
      |> Combination.permutate()
      |> Enum.each(fn tasks ->
        conn =
          post(conn, ~p"/api/tasks", %{
            "tasks" => tasks
          })

        assert json_response(conn, 200) == %{
                 "tasks" => [
                   %{"command" => "touch /tmp/file1", "name" => "task-1"},
                   %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3"},
                   %{"command" => "cat /tmp/file1", "name" => "task-2"},
                   %{"command" => "rm /tmp/file1", "name" => "task-4"}
                 ]
               }
      end)
    end


    test "returns an ordered list of tasks as a bash script", %{conn: conn} do
      tasks = [
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
        },
        %{
          "name" => "task-1",
          "command" => "touch /tmp/file1"
        }
      ]

      expected_response = """
      #!/usr/bin/env bash
      touch /tmp/file1
      echo 'Hello World!' > /tmp/file1
      cat /tmp/file1
      rm /tmp/file1
      """

      tasks
      |> Combination.permutate()
      |> Enum.each(fn tasks ->
        conn =
          post(conn, ~p"/api/tasks", %{
            "tasks" => tasks,
            "format" => "bash_script"
          })

        assert text_response(conn, 200) == expected_response
      end)
    end
  end
end