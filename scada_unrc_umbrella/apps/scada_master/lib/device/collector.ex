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
    GenServer.cast(server, substation)
  end

  ## Server Callbacks
  # def init(:ok) do
  #   Logger.info "Init collector " 
  #   #dev_table = Application.get_env(:scada_master,:device_table) #save the device table configured    
  #   {:ok, {dev_table}}
  # end

  def handle_call({:lookup}, _from, { _} = state) do
      {:noreply}
  end

  def handle_cast(substation) do
    #ip_sub = SCADAMaster.Device.Substation.get(substation,"ip")
    Logger.info "Collect Substation 1 from ip "
    # Logger.info ip_sub
    
    # SCADAMaster.Device.Substation.put(substation,"v",3)
    # volt = SCADAMaster.Device.Substation.get(substation,"v")
    # Logger.info "Substation 1 voltage "
    # Logger.info volt
    #reg_table  = Application.get_env(:scada_master,:register_table) #registrer table configured    
    
    {:noreply}
  end

end
