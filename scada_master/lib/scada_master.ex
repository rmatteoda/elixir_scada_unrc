defmodule SCADAMaster.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised (Ecto repository and Main Supervisor)
    children = [
      ScadaMaster.Repo,
      {SCADAMaster.Device.Supervisor, []}
    ]
    
    opts = [strategy: :one_for_one, name: SCADAMaster.Supervisor]
    Supervisor.start_link(children, opts)
  end

end