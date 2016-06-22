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
    {:ok, substation} = read_modbus(substation)
    Logger.debug "Collect called from supervisor " 
    SCADAMaster.Storage.StorageBind.dump_substation(substation)
    {:noreply, state}
  end

  defp read_modbus(substation) do
    ip_substation = SCADAMaster.Device.Substation.get(substation,"ip")
    
    SCADAMaster.Device.Substation.put(substation,"voltage",3.0)
    SCADAMaster.Device.Substation.put(substation,"current",1)
    #{:ok, pid} = ExModbus.Client.start_link %{ip: ip_substation}
    #ExModbus.Client.read_data pid, 1, 0x1, 2

    {:ok, substation}
  end

end
