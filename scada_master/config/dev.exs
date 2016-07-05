use Mix.Config

config :scada_master, ScadaMaster.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "scada_master_unrc",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
