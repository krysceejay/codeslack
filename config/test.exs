import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :codeslack, Codeslack.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "codeslack_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :codeslack, CodeslackWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "wmcvpYhJ7diY6/YiCMLtLzgG5/+Vqa6lYwue1DtRe+za6G/gpGlS9ULYn9vRRdsK",
  server: false

# In test we don't send emails.
config :codeslack, Codeslack.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
