defmodule SCADAMaster.Device.Collector do

  use GenServer
  require Logger

  ## Client API

  @doc """
  Starts the collector.
  """
  def start_link do
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
    ip_sub = SCADAMaster.Device.Substation.get(substation,"ip")
    Logger.debug "Collect Substation values from device ip " <> ip_sub  

    SCADAMaster.Device.Substation.put(substation,"v",3)
    volt = SCADAMaster.Device.Substation.get(substation,"v")
    Logger.debug "Substation voltage "
    Logger.debug volt
    
    {:noreply, state}
  end

end
