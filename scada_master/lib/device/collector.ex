defmodule SCADAMaster.Device.Collector do

  use GenServer
  require Logger

  # Register Offset Code
  @voltage_a_offs       0x01
  @voltage_b_offs       0x03
  @voltage_c_offs       0x05
  @current_a_offs       13
  @current_b_offs       15
  @current_c_offs       17
  @actvpower_a_offs     25
  @reactvpower_a_offs   31
  
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
      {:error, reason} -> Logger.error "Error: #{reason}"
    end

    {:noreply, state}
  end

  defp read_modbus(substation) do
    
    ip_substation = SCADAMaster.Device.Substation.get(substation,"ip")    
    
    try do
      {:ok, val} = read_register(ip_substation,@voltage_a_offs)
      SCADAMaster.Device.Substation.put(substation,"voltage_a",val)
      
      SCADAMaster.Device.Substation.put(substation,"voltage_b",3.0)
      SCADAMaster.Device.Substation.put(substation,"voltage_v",3.0)
      SCADAMaster.Device.Substation.put(substation,"current_a",1.0)
      SCADAMaster.Device.Substation.put(substation,"current_b",1.0)
      SCADAMaster.Device.Substation.put(substation,"current_c",1.0)
      SCADAMaster.Device.Substation.put(substation,"actpower_a",1.0)
      SCADAMaster.Device.Substation.put(substation,"reactpower_a",1.0)
    
      {:ok, substation}
    rescue
      # e -> {:error, "read_modbus: modbus client error for substation ip " <> ip_substation}
      e -> {:error, e}
    end
    
  end

  defp read_register(ip_substation, register_offset) do
        
    try do
      #Logger.debug "connect to " <> "'" <> ip_substation <> "'"
      #{:ok, pid} = ExModbus.Client.start_link %{ip: '192.168.88.112'}
      #Logger.debug "connected. reading... "
      #response = ExModbus.Client.read_data pid, 1, register_offset, 2
      #{:read_holding_registers, values} = Map.get(response, :data)  
      values = [123,123]            
      value = List.first(values)   
      float_val = value / 1           
      {:ok, float_val} 
    rescue
      e -> Logger.error "read_register: modbus client error for substation ip " <> ip_substation
      {:ok, [0.0,0.0]} 
    end
    
  end
end
