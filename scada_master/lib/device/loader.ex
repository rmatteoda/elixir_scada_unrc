defmodule SCADAMaster.Device.Loader do

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
  def load(server) do
    GenServer.cast(server, {:load})
  end

  ## Server Callbacks
  def init(:ok) do
    Logger.debug "Set config tables " 
    dev_table = Application.get_env(:scada_master,:device_table) #save the device table configured    
    {:ok, {dev_table}}
  end

  def handle_cast({:load}, {dev_table}) do
    #read config for each substatioon 
    Enum.each(dev_table, fn(subconfig) -> 
      Logger.debug "Create first substation from config" 
      {:ok, substation} = SCADAMaster.Device.Substation.start_link
    
      Logger.debug "Set ip and name for substation" 
      SCADAMaster.Device.Substation.put(substation,"ip",subconfig.ip)
      SCADAMaster.Device.Substation.put(substation,"subname",subconfig.name)

      Logger.debug "Collect values from device in substation" 
      {:ok, collector} = SCADAMaster.Device.Collector.start_link
      SCADAMaster.Device.Collector.collect(collector,substation)
    end)

    {:noreply, {dev_table}}
  end

end
