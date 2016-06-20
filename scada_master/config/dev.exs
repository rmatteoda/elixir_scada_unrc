use Mix.Config

config :scada_master, ScadaMaster.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_scada_master_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
