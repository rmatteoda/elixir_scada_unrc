defmodule SCADAMaster.Device.Collector do

  use GenServer
  require Logger

  ## Client API
  @doc """
  Starts the collector.
  """
  def start_link do
    Logger.debug "Collector started from supervisor " 
    GenServer.start_link(__MODULE__, :ok, [])
  end

  @doc """
  recorrer la tabla de device y crear por cada key una substation con key, ip .
  """
  def collect(server,substation) do
    GenServer.cast(server, {:collect, substation})
  end

  ## Server Callbacks
  def handle_call({:lookup}, _from, { _} = state) do
      {:noreply, state}
  end

  def handle_cast({:collect, substation}, state) do
    Logger.debug "Collect called from supervisor " 

    case read_modbus(substation) do
      {:ok, substation} -> SCADAMaster.Storage.StorageBind.dump_substation(substation)
      {:error, msgerror} -> Logger.error msgerror
    end

    {:noreply, state}
  end

  defp read_modbus(substation) do
    ip_substation = SCADAMaster.Device.Substation.get(substation,"ip")    
    SCADAMaster.Device.Substation.put(substation,"voltage",3.0)
    SCADAMaster.Device.Substation.put(substation,"current",1)
    
    try do
      #{:ok, pid} = ExModbus.Client.start_link {ip_substation}
      #ExModbus.Client.read_data pid, 1, 0x1, 2
      {:ok, substation}
    rescue
      e -> {:error, "read_modbus: modbus client error for substation ip " <> ip_substation}
    end
    
  end

end
