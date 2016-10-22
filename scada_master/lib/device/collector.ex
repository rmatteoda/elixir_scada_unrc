defmodule SCADAMaster.Device.Collector do

  use GenServer
  require Logger

  # Register Offset Codes
  @voltage_a_offs            0x01
  @voltage_b_offs            0x03
  @voltage_c_offs            0x05
  @current_a_offs            13
  @current_b_offs            15
  @current_c_offs            17
  @actvpower_a_offs          25
  @actvpower_b_offs          27
  @actvpower_c_offs          29
  @reactvpower_a_offs        31
  @reactvpower_b_offs        33
  @reactvpower_c_offs        35
  @actvpower_offs            65
  @reactvpower_offs          67
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
  def collect(server,substation_name, substation_ip) do
    GenServer.cast(server, {:collect, substation_name, substation_ip})
  end

  ## Server Callbacks
  def handle_call({:lookup}, _from, { _} = state) do
      {:noreply, state}
  end

  def handle_cast({:collect, substation_name, substation_ip}, state) do
    case load_modbus(substation_ip) do
      {:ok, device} -> SCADAMaster.Storage.StorageBind.dump_substation(substation_name,device)
      {:error, reason} -> Logger.error "Error: #{reason}"
    end

    {:noreply, state}
  end

  defp load_modbus(substation_ip) do
    
    try do
      {:ok, pid, status} = connect_device(substation_ip)
      
      case status do
        :on -> read_modbus(pid)
        :off -> Logger.error "MODBUS Off from: " <> substation_ip
                {:error, "modbus disconected"}
      end         
        
    rescue
      e -> {:error, e}
    end
    
  end

  defp read_modbus(pid) do
    try do
      Logger.debug "reading modbus register "
      
      {:ok, vol_a} = read_register(pid,@voltage_a_offs)
      {:ok, vol_b} = read_register(pid,@voltage_b_offs)
      {:ok, vol_c} = read_register(pid,@voltage_c_offs)
      {:ok, cur_a} = read_register(pid,@current_a_offs)
      {:ok, cur_b} = read_register(pid,@current_b_offs)
      {:ok, cur_c} = read_register(pid,@current_c_offs)
      {:ok, acpw_a} = read_register(pid,@actvpower_a_offs)
      {:ok, acpw_b} = read_register(pid,@actvpower_b_offs)
      {:ok, acpw_c} = read_register(pid,@actvpower_c_offs)      
      {:ok, reacpw_a} = read_register(pid,@reactvpower_a_offs)
      {:ok, reacpw_b} = read_register(pid,@reactvpower_b_offs)
      {:ok, reacpw_c} = read_register(pid,@reactvpower_c_offs)
      {:ok, pow_ac} = read_register(pid,@actvpower_offs)
      {:ok, pow_reac} = read_register(pid,@reactvpower_offs)
      {:ok, unbalance_v} = read_register(pid,@unbalance_voltage_offs)
      {:ok, unbalance_c} = read_register(pid,@unbalance_current_offs)
      
      collected_time = Ecto.DateTime.utc
      
      device = %SCADAMaster.Storage.Device{devdate: collected_time, 
                                voltage_a: vol_a, 
                                voltage_b: vol_b, 
                                voltage_c: vol_c, 
                                current_a: cur_a,
                                current_b: cur_b,
                                current_c: cur_c,
                                activepower_a: acpw_a,
                                activepower_b: acpw_b,
                                activepower_c: acpw_c,
                                reactivepower_a: reacpw_a,
                                reactivepower_b: reacpw_b,
                                reactivepower_c: reacpw_c,
                                totalactivepower: pow_ac,
                                totalreactivepower: pow_reac,
                                unbalance_voltage: unbalance_v,
                                unbalance_current: unbalance_c,
                                substation_id: 1}

      {:ok, device}
    rescue
      e -> {:error, e}
    end
  end

  defp connect_device(ip_substation) do
    Logger.debug "connecting to " <> ip_substation
    #{:ok, ip_a, ip_b, ip_c, ip_d} = parseIp(ip_substation)
    
    #{:ok, pid} = ExModbus.Client.start_link {ip_a, ip_b, ip_c, ip_d}
    #status = ExModbus.Client.status pid
    status = :on
    pid = 1
    {:ok, pid, status}   
  end

  defp read_register(pid, register_offset) do        
    try do      
      #response = ExModbus.Client.read_data pid, 1, register_offset, 2
      #{:read_holding_registers, values} = Map.get(response, :data)  
      #match return value list to values [a, b]
      #get the float value
      [value1, value2] = [17249, 886]

      float_byte1 = value1 |> :binary.encode_unsigned |> Base.encode16    
      float_byte2 = value2 |> :binary.encode_unsigned |> Base.encode16

      <<float_val::size(32)-float>> = Base.decode16!(float_byte1 <> float_byte2)
         
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
