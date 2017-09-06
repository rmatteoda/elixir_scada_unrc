defmodule SCADAMaster.Device.Scheduler do
  use GenServer
  require Logger

# configure time in ms to collect data from scada devies.
# The time for collect data from can be set in:
  #`config :scada_master, ScadaMaster, collect_each: 1000`
  
  ## Client API
  @doc """
  Starts the scheduler.
  """
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  @doc """
  This process will call the collector to get modbus valus every @collect_time configured
  """
  def init(state) do
    Logger.debug "Start Scheduler handler " 

    config_substations()

    # Schedule the work
    do_schedule()

    {:ok, state}      
  end

  def handle_info(:collect, state) do
    #load substation values using collector 
    #load weather data of Rio Cuarto from openweather api
    #collec()
    
    SCADAMaster.Device.WeatherAccess.collect_weather
    
    # Schadule the work
    do_schedule()

    {:noreply, state}
  end

  defp do_schedule() do
    Process.send_after(self(), :collect, collect_each()) 
  end

  @doc """
  for each substation configured call the collector to load the substation values from modbus device
  """
  def collec() do
    # get the table configured with all substation ips
    substation_list = Application.get_env(:scada_master,:device_table) #save the device table configured    
    
    {:ok, collector_pid} = SCADAMaster.Device.Supervisor.start_collector
    do_collect_substations collector_pid, substation_list
  end

  defp do_collect_substations(collector_pid, [subconfig | substation_list]) do
    SCADAMaster.Device.Collector.collect(collector_pid,subconfig.name,subconfig.ip)    
    do_collect_substations collector_pid, substation_list
  end

  defp do_collect_substations(_, []), do: nil

  #load substations from config file and store it if does not exist
  defp config_substations() do
    sub_table = Application.get_env(:scada_master,:device_table)
    SCADAMaster.Schema.Importer.import_substations sub_table
  end

  defp collect_each do
    Application.get_env(:scada_master, ScadaMaster)
    |> Keyword.fetch!(:collect_each)
  end
end
