defmodule SCADAMaster.MasterCron do
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
    Logger.info "Connectiong to Senpron "
    # Save in DB
    {:ok, pid} = ExModbus.Client.start_link {192, 168, 0, 106}
    IO.puts "Connected Success"
    
    IO.puts "Reading register data"
    #ExModbus.Client.read_data pid, 1, 0x1, 2
    
    # Start the timer again
    Process.send_after(self(), :work, 30 * 1000) # In 1 minute

    {:noreply, state}
  end
end