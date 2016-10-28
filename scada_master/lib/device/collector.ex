defmodule SCADAMaster.Device.Collector do

  use GenServer
  require Logger

  # Register Offset Codes
  @voltage_a_offs            0x01
  @voltage_b_offs            0x03
  @voltage_c_offs            0x05

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
    case load_modbus(substation_ip,substation_name) do
      {:ok, device} -> SCADAMaster.Storage.StorageBind.storage_collected_data(device)
      {:error, reason} -> Logger.error "Error: #{reason}"
    end

    {:noreply, state}
  end

  defp load_modbus(substation_ip,substation_name) do
    
    try do
      {:ok, pid, status} = do_connect(substation_ip)
      
      case status do
        :on -> read_modbus(pid,substation_name)
        :off -> Logger.error "MODBUS Off from: " <> substation_ip
                {:error, "modbus disconected"}
      end         
        
    rescue
      e -> {:error, e}
    end
    
  end

  defp read_modbus(pid,substation_name) do
    try do
      Logger.debug "reading modbus register "
      
      volt_cfg = [%{offset: 1, name: "voltage_a"},%{offset: 3, name: "voltage_b"},%{offset: 5, name: "voltage_c"}]
    
            
      {:ok, vol_a} = read_register(pid,@voltage_a_offs)
      
      collected_time = Ecto.DateTime.utc
      device = %SCADAMaster.Storage.Device{devdate: collected_time}

      #case SCADAMaster.Storage.StorageBind.find_substation_id_by_name(substation_name) do 
      #   nil -> {:error, "Substation not found in DB to save collected data"}
      #   sub_id -> device = %SCADAMaster.Storage.Device{devdate: collected_time, 
      #                           voltage_a: vol_a, 
      #                           voltage_b: vol_b, 
      #                           voltage_c: vol_c, 
      #                           current_a: cur_a,
      #                           current_b: cur_b,
      #                           current_c: cur_c,
      #                           activepower_a: acpw_a,
      #                           activepower_b: acpw_b,
      #                           activepower_c: acpw_c,
      #                           reactivepower_a: reacpw_a,
      #                           reactivepower_b: reacpw_b,
      #                           reactivepower_c: reacpw_c,
      #                           totalactivepower: pow_ac,
      #                           totalreactivepower: pow_reac,
      #                           unbalance_voltage: unbalance_v,
      #                           unbalance_current: unbalance_c,
      #                           substation_id: sub_id}
      #              {:ok, device}
      # end
      {:ok, device}
    rescue
      e -> {:error, e}
    end
  end

  defp do_connect(ip_substation) do
    Logger.debug "connecting to #{ip_substation}"
    {:ok, {ip_a, ip_b, ip_c, ip_d}} = ip_substation 
                                      |> String.to_char_list 
                                      |> :inet_parse.address

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

#What is the way to convert %{"foo" => "bar"} to %{foo: "bar"} in Elixir
#   defmodule User do
#     defstruct [:id, :name]
#     @type t :: %__MODULE__{id: integer, name: String.t}
#   end
#   Indeed, it works if the map keys are atoms:
# iex> struct(User, %{id: 1, name: "weppos", foo: "bar"})
# %User{id: 1, name: "weppos"}
#otra manera
# %{"foo" => "bar"}
# |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
#https://github.com/appcues/exconstructor

#suggestion by Jose Valim:
  def to_struct(kind, attrs) do
      struct = struct(kind)
      Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
        case Map.fetch(attrs, Atom.to_string(k)) do
          {:ok, v} -> %{acc | k => v}
          :error -> acc
        end
      end
  end

end

defmodule SubstationData do
  defstruct [:voltage_a, :voltage_b, :voltage_c]
    
end

