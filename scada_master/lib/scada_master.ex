defmodule SCADAMaster.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(ScadaMaster.Repo, []),
      # Start the endpoint when the application starts
      supervisor(SCADAMaster.Device.Supervisor, []),

      worker(SCADAMaster.Device.Scheduler, [], restart: :transient),
      worker(SCADAMaster.Schema.Reporter, [], restart: :transient)
    ]
    
    opts = [strategy: :one_for_one, name: SCADAMaster.Supervisor]
    Supervisor.start_link(children, opts)
  end

end