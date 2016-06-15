defmodule SCADAMaster.Device.Scheduler do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 15 * 1000) # In 1 minute - ver de agregar tiempo configurado
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.info "Scheduler handler " 
    
    Logger.info "Init Substation Loader "    
    {:ok, loader} = SCADAMaster.Device.Loader.start_link       
    SCADAMaster.Device.Loader.load(loader);

    # Start the timer again
    Process.send_after(self(), :work, 15 * 1000) # In 1 minute - ver de agregar tiempo configurado
    {:noreply, state}
  end
end
    #{:ok, pid} = ExModbus.Client.start_link {192, 168, 0, 106}
    
    #Logger.info "Reading register data"
    #ExModbus.Client.read_data pid, 1, 0x1, 2
    #Logger.info "Readded Success"
