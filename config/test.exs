import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :task_service, TaskServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RhiVPbejsQ3vAEgft4qFb5WeYT4ix6odjR/pH1H5bgt/PfZKkjzN/hNDh41g/3Cc",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
