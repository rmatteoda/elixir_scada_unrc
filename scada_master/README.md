# SCADAMaster

#to create DB, migrate scheme and seed first data
* `mix do deps.get, compile`
* `mix ecto.create`
* `mix ecto.migrate`
* `mix run priv/repo/seeds.exs`
* `iex -S mix`
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

TODO:
- Task?
- Correr app en Ubuntu on init.d
- logger file name with timestamp
- Test de funcionamiento de todo y condiciones de falla
- Como se ejecuta siempre e instalar en windows: mix run --no-halt? - escript - https://github.com/bitwalker/exrm  ?
   http://tjheeta.github.io/2014/12/09/elixir-app-startup-and-runit/ 
   http://stackoverflow.com/questions/3513944/erlang-application-launch-on-a-windows-server
   https://github.com/johnhamelink/exrm_deb
- revisar mnesia https://elixirschool.com/lessons/specifics/mnesia/

{:ok, pid} = ExModbus.Client.start_link %{ip: '192.168.88.112'}

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

