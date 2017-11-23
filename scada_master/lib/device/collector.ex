defmodule SCADAMaster.Device.Collector do

  use GenServer
  require Logger

  ## Client API
  @doc """
  Starts the collector.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Connect to substation using modbus and read all register of senpron device
  """
  def collect(server,substation_name, substation_ip) do
    GenServer.cast(server, {:collect, substation_name, substation_ip})
  end

  ## Server Callbacks
  def handle_call({:lookup}, _from, {_} = state) do
      {:noreply, state}
  end

  def handle_cast({:collect, substation_name, substation_ip}, state) do
    case do_read_registers(substation_ip,substation_name) do
      {:ok, substation_values} -> SCADAMaster.Schema.StorageBind.storage_collected_data(substation_values)
      {:error, reason} -> Logger.error "Error: #{reason}"
    end
    {:noreply, state}
  end

  #Read sempron register using ex_modbus library
  defp do_read_registers(substation_ip,substation_name) do   
    {pid, status} = do_connect(substation_ip)
    do_read_modbus(pid,substation_name,status)
  end

  #buid register map from struc for substation with all offsets and register key defined
  #iterate over map to read all registers
  defp do_read_modbus(pid,substation_name,status) do
    try do
      #Logger.debug "reading modbus register "          
      register_map = Map.from_struct(SCADAMaster.Device.SubstationStruct)
      substationdata = Map.new(register_map, fn {key, val} -> 
                                               {:ok, val} = do_read_register(pid,val,status)
                                               {key, val} 
                                             end)
     
      case SCADAMaster.Schema.StorageBind.find_substation_id_by_name(substation_name) do 
          nil -> {:error, "Substation not found in DB to save collected data"}
          sub_id -> substation_values = Map.put(substationdata, :substation_id, sub_id)
                    {:ok, substation_values}
      end
    rescue
      e -> {:error, e}
    end
  end

  #Read modbus register using the pid of the connection, register offset
  defp do_read_register(pid, register_offset, :connected) do        
    Logger.debug "Reading on MODBUS connected "   
    try do      
      response = ExModbus.Client.read_data pid, 1, register_offset, 2
      {:read_holding_registers, [modbus_reg_1, modbus_reg_2]} = Map.get(response, :data)  
      #[modbus_reg_1, modbus_reg_2] = [17249, 886]

      float_byte1 = modbus_reg_1 |> :binary.encode_unsigned() |> Base.encode16()    
      float_byte2 = modbus_reg_2 |> :binary.encode_unsigned() |> Base.encode16()

      <<float_val::size(32)-float>> = Base.decode16!(float_byte1 <> float_byte2)
         
      {:ok, float_val} 
    rescue
      e -> Logger.error "exception on read_register: " <> e
      {:ok, 0.1} 
    end    
  end

  #Create default map with values on connection error (nodbus status off)
  defp do_read_register(_pid, _register_offset, :failed_connect) do     
    {:ok, 0.0} 
  end

  defp do_connect(substation_ip) do
    Logger.debug "connecting to #{substation_ip}"
    {:ok, {ip_a, ip_b, ip_c, ip_d}} = substation_ip |> to_charlist() |> :inet_parse.address()
    
    {:ok, pid} = ExModbus.Client.start_link {ip_a, ip_b, ip_c, ip_d}
    socket_state = ExModbus.Client.socket_state pid
    Logger.debug "connected state #{socket_state}"
    
    {pid, socket_state}
  end
end

