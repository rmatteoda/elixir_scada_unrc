defmodule SCADAMaster.Device.Scheduler do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(loader) do
    Logger.debug "Start System from Scheduler handler " 
    Process.send_after(self(), :work, 15 * 1000) # In 1 minute - ver de agregar tiempo configurado
    SCADAMaster.Device.Loader.start_link       
    #{:ok, loader}
  end

  def handle_info(:work, loader) do
    #load substation values
    SCADAMaster.Device.Loader.load(loader);

    # Start the timer again
    Process.send_after(self(), :work, 30 * 1000) # In 1 minute - ver de agregar tiempo configurado
    {:noreply, loader}
  end
end
