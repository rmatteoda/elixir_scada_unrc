defmodule SCADAMaster.Device.Scheduler do
  use GenServer, restart: :transient
  require Logger

  alias SCADAMaster.Device.Collector
  alias SCADAMaster.Device.WeatherAccess

# configure time in ms to collect data from scada devies.
# The time for collect data from can be set in:
  #`config :scada_master, ScadaMaster, collect_each: 1000`
  
  ## Client API
  @doc """
  Starts the scheduler.
  """
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  This process will call the collector to get modbus valus every @collect_time configured
  """
  def init(state) do
    Logger.debug "Start Scheduler handler " 
    
    {:ok, collector_pid} = Collector.start_link
    config_substations()

    # Schedule the work
    do_schedule()

    {:ok, collector_pid}      
  end

  def handle_info(:collect, collector_pid) do
    Logger.debug "Handle Info Scheduler handler " 
    #load substation values using collector 
    collec(collector_pid)
    
    #load weather data of Rio Cuarto from openweather api
    #WeatherAccess.collect_weather
    
    # Schadule the work
    do_schedule()

    {:noreply, collector_pid}
  end

  defp do_schedule() do
    Process.send_after(self(), :collect, collect_each()) 
  end

  @doc """
  for each substation configured call the collector to load the substation values from modbus device
  """
  def collec(collector_pid) do
    # get the table configured with all substation ips
    substation_list = Application.get_env(:scada_master,:device_table) #save the device table configured    
    
    do_collect_substations collector_pid, substation_list
  end

  defp do_collect_substations(collector_pid, [subconfig | substation_list]) do
    Collector.collect(collector_pid,subconfig.name,subconfig.ip)    
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
