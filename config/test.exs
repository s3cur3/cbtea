import Config

alias Swoosh.Adapters.Test

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used

# In test we don't send emails.
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :cbt, Cbt.Mailer, adapter: Test

config :cbt, Cbt.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "cbt_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  # We don't run a server during test. If one is required,
  # you can enable the server option below.
  pool_size: 10

config :cbt, CbtWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Wl7i4gJdb6onvOvyd1KM85d29DOL44h4QTxbZbQVRohUXxsMZ5YxSYJaETgwTO1v",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
