defmodule SCADAMaster.Storage.Reporter do
  use GenServer
  require Logger

# configure time in ms to collect data from scada devies.
  @report_time 60 * 60000 #  (60 minutos)
  @report_path "/Users/rammatte/Workspace/UNRC/SCADA/elixir/scada_project/scada_master/"

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    do_schedule()
    {:ok, state} 
  end

  def handle_info(:tick, state) do
    
    report()

    # Start the timer again
    do_schedule()
    {:noreply, state}
  end

  defp do_schedule() do
    Process.send_after(self(), :tick, @report_time) 
  end
  
   @doc """
  for each substation report into a csv file all data collected
  """
  def report() do
    # get the table configured with all substation ips
    substation_list = Application.get_env(:scada_master,:device_table) #save the device table configured    
    
    do_report substation_list
  end

  defp do_report([subconfig | substation_list]) do

    case SCADAMaster.Storage.ScadaQuery.find_substation_id_by_name(subconfig.name) do 
      nil -> Logger.error "Substation not found in DB to generate report"
      sub_id -> dev_table_result = SCADAMaster.Storage.ScadaQuery.find_collecteddata_by_subid(sub_id)
                do_report_table(dev_table_result,subconfig.name)
    end

    do_report substation_list
  end

  defp do_report([]), do: nil

  defp do_report_table(dev_table_result, substation_name) do
    file_name = Path.join(@report_path, substation_name <> "_data.csv")
    f = File.open!(file_name, [:write, :utf8])

    Enum.each(dev_table_result, fn(device) -> 
      IO.write(f, CSVLixir.write_row([device.substation_id,device.voltage_a, device.voltage_b, device.voltage_c,
                                      device.current_a, device.current_b, device.current_c,
                                      device.activepower_a, device.activepower_b, device.activepower_c,
                                      device.reactivepower_a, device.reactivepower_b, device.reactivepower_c,
                                      device.totalactivepower,device.totalreactivepower,
                                      device.unbalance_voltage,device.unbalance_current]))
    end)  
    
    File.close(f)

  end


end
