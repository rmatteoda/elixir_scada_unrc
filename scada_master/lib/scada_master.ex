defmodule SCADAMaster do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    children = [
      # Define workers and child supervisors to be supervised
      supervisor(ScadaMaster.Repo, []),
      supervisor(SCADAMaster.Device.Supervisor, []),
      worker(SCADAMaster.Device.Scheduler, [], restart: :transient),
      worker(SCADAMaster.Storage.Reporter, [], restart: :transient)
    ]
    opts = [strategy: :one_for_one, name: SCADAMaster.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule ScadaMaster.Repo do
  use Ecto.Repo, otp_app: :scada_master
end