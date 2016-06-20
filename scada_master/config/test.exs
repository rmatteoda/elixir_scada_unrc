use Mix.Config

config :scada_master, ScadaMaster.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_scada_master_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
