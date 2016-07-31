defmodule SCADAMaster.Device.Scheduler do
  use GenServer
  require Logger

# configure time in ms to collect data from scada devies.
  @collect_time 30000

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(loader) do
    Logger.debug "Start System from Scheduler handler " 
    Process.send_after(self(), :work, @collect_time) 
    SCADAMaster.Device.Loader.start_link       
  end

  def handle_info(:work, loader) do
    #load substation values
    SCADAMaster.Device.Loader.load(loader);

    # Start the timer again
    Process.send_after(self(), :work, @collect_time) 
    {:noreply, loader}
  end
end
