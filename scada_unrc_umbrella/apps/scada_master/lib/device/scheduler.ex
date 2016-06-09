defmodule SCADAMaster.Device.Scheduler do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 30 * 1000) # In 1 minute
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Connect to device and read register (V, I, etc)
    #dev_table = Application.get_env(:scada_master,:device_table)
    #ip = dev_table[:trafo1]
    
    Logger.info "Connectiong to Senpron at ip " 
    #Logger.info ip
    # Save in DB
    {:ok, pid} = ExModbus.Client.start_link {192, 168, 0, 106}
    Logger.info "Connected Success"
    
    Logger.info "Reading register data"
    ExModbus.Client.read_data pid, 1, 0x1, 2
    Logger.info "Readded Success"
    
    # Start the timer again
    #Process.send_after(self(), :work, 30 * 1000) # In 1 minute

    {:noreply, state}
  end
end