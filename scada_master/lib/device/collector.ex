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
  @actvpower_a_offs          25
  @actvpower_b_offs          27
  @actvpower_c_offs          29
  @reactvpower_a_offs        31
  @reactvpower_b_offs        33
  @reactvpower_c_offs        35
  @actvpower_offs       65
  @reactvpower_offs     67
  @unbalance_voltage_offs    71
  @unbalance_current_offs    73
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
    Logger.debug "Collect called from supervisor " 

    case load_modbus(substation) do
      {:ok, substation} -> SCADAMaster.Storage.StorageBind.dump_substation(substation)
      {:error, reason} -> Logger.error "Error: #{reason}"
    end

    {:noreply, state}
  end

  defp load_modbus(substation) do
    
    ip_substation = SCADAMaster.Device.Substation.get(substation,"ip")    
    
    try do
      {:ok, pid, status} = connect_device(ip_substation)
      
      case status do
        :on -> read_modbus(substation, pid)
               {:ok, substation}
        :off -> Logger.error "MODBUS Off from: " <> ip_substation
                {:error, "modbus disconected"}
      end         
        
    rescue
      e -> {:error, e}
    end
    
  end

  defp read_modbus(substation, pid) do
    try do
      Logger.debug "reading modbus register "
      
      {:ok, val} = read_register(pid,@voltage_a_offs)
      SCADAMaster.Device.Substation.put(substation,"voltage_a",val)
      
      {:ok, val_b} = read_register(pid,@voltage_b_offs)
      SCADAMaster.Device.Substation.put(substation,"voltage_b",val_b)
      
      {:ok, val_c} = read_register(pid,@voltage_c_offs)
      SCADAMaster.Device.Substation.put(substation,"voltage_c",val_c)

      {:ok, cur_a} = read_register(pid,@current_a_offs)
      SCADAMaster.Device.Substation.put(substation,"current_a",cur_a)
      
      {:ok, cur_b} = read_register(pid,@current_b_offs)
      SCADAMaster.Device.Substation.put(substation,"current_b",cur_b)
      
      {:ok, cur_c} = read_register(pid,@current_c_offs)
      SCADAMaster.Device.Substation.put(substation,"current_c",cur_c)
      
      {:ok, acpw_a} = read_register(pid,@actvpower_a_offs)
      SCADAMaster.Device.Substation.put(substation,"actpower_a",acpw_a)

      {:ok, acpw_b} = read_register(pid,@actvpower_b_offs)
      SCADAMaster.Device.Substation.put(substation,"actpower_b",acpw_b)

      {:ok, acpw_c} = read_register(pid,@actvpower_c_offs)
      SCADAMaster.Device.Substation.put(substation,"actpower_c",acpw_c)

      {:ok, reacpw_a} = read_register(pid,@reactvpower_a_offs)
      SCADAMaster.Device.Substation.put(substation,"reactpower_a",reacpw_a)

      {:ok, reacpw_b} = read_register(pid,@reactvpower_b_offs)
      SCADAMaster.Device.Substation.put(substation,"reactpower_b",reacpw_b)

      {:ok, reacpw_c} = read_register(pid,@reactvpower_c_offs)
      SCADAMaster.Device.Substation.put(substation,"reactpower_c",reacpw_c)

      {:ok, pow_ac} = read_register(pid,@actvpower_offs)
      SCADAMaster.Device.Substation.put(substation,"totalactpower",pow_ac)
      
      {:ok, pow_reac} = read_register(pid,@reactvpower_offs)
      SCADAMaster.Device.Substation.put(substation,"totalreactpower",pow_reac)
    
     {:ok, unbalance_v} = read_register(pid,@unbalance_voltage_offs)
      SCADAMaster.Device.Substation.put(substation,"unbalance_v",unbalance_v)

     {:ok, unbalance_c} = read_register(pid,@unbalance_current_offs)
      SCADAMaster.Device.Substation.put(substation,"unbalance_c",unbalance_c)
   
      {:ok, substation}
    rescue
      e -> {:error, e}
    end
  end

  defp connect_device(ip_substation) do
    Logger.debug "connecting to " <> ip_substation
    {:ok, ip_a, ip_b, ip_c, ip_d} = parseIp(ip_substation)
    
    {:ok, pid} = ExModbus.Client.start_link {ip_a, ip_b, ip_c, ip_d}
    status = ExModbus.Client.status pid
    #status = :on
    
    {:ok, pid, status}   
  end

  defp read_register(pid, register_offset) do        
    try do      
      response = ExModbus.Client.read_data pid, 1, register_offset, 2
      {:read_holding_registers, values} = Map.get(response, :data)  
      
      #get the float value 
      value1 = Enum.at(values,0,0)  
      byte1 = value1 |> :binary.encode_unsigned |> Base.encode16
    
      value2 = Enum.at(values,1,0) 
      byte2 = value2 |> :binary.encode_unsigned |> Base.encode16

      <<float_val::size(32)-float>> = Base.decode16!(byte1 <> byte2)
         
      {:ok, float_val} 

    rescue
      e -> Logger.error "read_register: " <> e
      {:ok, [0.0,0.0]} 
    end    
  end

  defp parseIp(ip_substation) do
    [ip_a,ip_b,ip_c,ip_d] = String.split(ip_substation,".")
    {ip_a_intVal, _} = Integer.parse(ip_a)
    {ip_b_intVal, _} = Integer.parse(ip_b)
    {ip_c_intVal, _} = Integer.parse(ip_c)
    {ip_d_intVal, _} = Integer.parse(ip_d)
    {:ok, ip_a_intVal, ip_b_intVal, ip_c_intVal, ip_d_intVal}
  end
end
