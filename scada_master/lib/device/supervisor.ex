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
      {SCADAMaster.Schema.Reporter, []},
      {SCADAMaster.Schema.EmailReporter, []}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end