# SCADAMaster

#to create DB, migrate scheme and seed first data
* `mix do deps.get, compile`
* `mix ecto.create`
* `mix ecto.migrate`
* `mix run priv/repo/seeds.exs`
* `iex -S mix`
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

TODO:
- Supervisor Tree - LISTO?
- Task?
- leer datos del equipo y pasar a valor float
- Definir DB tables and schemes
- Test
- Como se ejecuta siempre e instalar en windows: mix run --no-halt?

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

