defmodule SCADAMaster.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(ScadaMaster.Repo, []),
      supervisor(SCADAMaster.Device.Supervisor, []),

      worker(SCADAMaster.Device.Scheduler, [], restart: :transient),
      worker(SCADAMaster.Storage.Reporter, [], restart: :transient)
    ]
    
    opts = [strategy: :one_for_one, name: SCADAMaster.Supervisor]
    Supervisor.start_link(children, opts)
  end
end