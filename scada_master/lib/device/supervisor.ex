defmodule SCADAMaster.Device.Supervisor do
  use Supervisor

  # A simple module attribute that stores the supervisor name
  @name SCADAMaster.Device.Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: @name)
  end

  def init(_arg) do
    children = [
      {SCADAMaster.Device.Scheduler, []},
      {SCADAMaster.Schema.Reporter, []}
    ]
    #{:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)
    Supervisor.init(children, strategy: :one_for_one)
  end
end