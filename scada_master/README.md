# SCADAMaster

#to create DB, migrate scheme and seed first data
* `mix do deps.get, compile`
* `mix ecto.create`
* `mix ecto.migrate`
* `mix run priv/repo/seeds.exs`
* `iex -S mix`
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

Diseño TODO:
- Supervisor Tree
- Manage errors (DB connection and modbus connection or read)
- Task
- Logger definir estrategia
- Definir DB tables and schemes
- Test
- Como se ejecuta siempre : mix run --no-halt?
- Manejar modbus tpc y modbus rtu

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add scada_master to your list of dependencies in `mix.exs`:

        def deps do
          [{:scada_master, "~> 0.0.1"}]
        end

  2. Ensure scada_master is started before your application:

        def application do
          [applications: [:scada_master]]
        end

