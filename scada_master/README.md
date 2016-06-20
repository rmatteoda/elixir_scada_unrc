# SCADAMaster

**TODO: Add description**
#para la DB
* `mix do deps.get, compile`
* `mix ecto.create`
* `mix ecto.migrate`
* `mix run priv/repo/seeds.exs`
* `iex -S mix`
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

Diseño:

- Procesos, Agents y GenServers
- Supervisor Tree
- Task
- DB (cual usar o guardar en un archivo)
- Configuracion (ip modbus, port, registros a leer, mastercron time)
- Logger estrategia
- Como se ejecuta siempre : mix run --no-halt?
- Monitoreo de la app o visualizacion de datos
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

