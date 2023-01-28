# Running tests

```sh
mix deps.get
mix test
```

# Starting the API

```sh
mix deps.get
mix phx.server
```

Sending a request

```sh
curl -X POST http://localhost:4000/api/tasks \
    -H 'Content-Type: application/json' \
    -d '{
        "tasks": [
            {
                "name": "task-1",
                "command": "touch /tmp/file1"
            },
            {
                "name": "task-2",
                "command": "cat /tmp/file1",
                "requires": ["task-3"]
            },
            {
                "name": "task-3",
                "command": "echo \'Hello World!\' > /tmp/file1",
                "requires": ["task-1"]
            },
            {
                "name": "task-4",
                "command": "rm /tmp/file1",
                "requires": ["task-2", "task-3"]
            }
        ]
    }'
```

Sending a request to return a bash script

```sh
curl -X POST http://localhost:4000/api/tasks \
    -H 'Content-Type: application/json' \
    -d '{
        "format": "bash_script",
        "tasks": [
            {
                "name": "task-1",
                "command": "touch /tmp/file1"
            },
            {
                "name": "task-2",
                "command": "cat /tmp/file1",
                "requires": ["task-3"]
            },
            {
                "name": "task-3",
                "command": "echo \'Hello World!\' > /tmp/file1",
                "requires": ["task-1"]
            },
            {
                "name": "task-4",
                "command": "rm /tmp/file1",
                "requires": ["task-2", "task-3"]
            }
        ]
    }'
```

# TaskService

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
