use Mix.Config

# Configuration for development

# Configure your database for develop
config :scada_master, ScadaMaster.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "scada_master_unrc",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

# Do not include metadata nor timestamps in development logs
config :logger, format: "[$level] $message\n"
