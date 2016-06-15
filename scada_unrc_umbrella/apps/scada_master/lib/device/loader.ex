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
    Logger.info "Set config tables " 
    dev_table = Application.get_env(:scada_master,:device_table) #save the device table configured    
    {:ok, {dev_table}}
  end

  def handle_cast({:load}, {dev_table}) do
    ip_sub1 = dev_table[:sub1].ip
    name_sub1 = dev_table[:sub1].name
    
    Logger.info "Load substation 1 " 
    {:ok, substation} = SCADAMaster.Device.Substation.start_link
    SCADAMaster.Device.Substation.put(substation,"ip",ip_sub1)
    SCADAMaster.Device.Substation.put(substation,"subname",name_sub1)

    {:ok, collector} = SCADAMaster.Device.Collector.start_link
    SCADAMaster.Device.Collector.collect(collector,substation)
    
    #reg_table  = Application.get_env(:scada_master,:register_table) #registrer table configured    
    
    {:noreply, {dev_table}}
  end

end
