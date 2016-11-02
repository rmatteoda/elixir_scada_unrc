defmodule SCADAMaster.Device.Scheduler do
  use GenServer
  require Logger

# configure time in ms to collect data from scada devies.
  @collect_time 1 * 30000 # x minutes (1)

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
    # Schedule the work
    do_schedule()

    {:ok, state}      
  end

  def handle_info(:work, state) do
    #load substation values using collector
    collec()
    SCADAMaster.Device.WeatherApi.collect_weather
    # Schadule the work
    do_schedule()

    {:noreply, state}
  end

  defp do_schedule() do
    Process.send_after(self(), :work, @collect_time) 
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

end
