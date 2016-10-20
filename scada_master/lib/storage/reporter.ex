defmodule SCADAMaster.Storage.Reporter do
  use GenServer
  require Logger

# configure time in ms to collect data from scada devies.
  @report_time 1 * 60000 #  (60 minutos)

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    do_schedule()
    {:ok, state} 
  end

  def handle_info(:tick, state) do
    Logger.debug "Generate Reporter " 
    
    found = SCADAMaster.Storage.ScadaQuery.find_substation_by_name("trafo1")  
    substation_db_id = List.first(found).id
    #reporter_time = Ecto.DateTime.utc

    dev_table_result = SCADAMaster.Storage.ScadaQuery.find_collecteddata_by_subid(substation_db_id) 
    report(dev_table_result)

    # Start the timer again
    do_schedule()
    {:noreply, state}
  end

  defp do_schedule() do
    Process.send_after(self(), :tick, @report_time) 
  end
  
  def report(dev_table_result) do
    
    f = File.open!("/Users/rammatte/Workspace/UNRC/SCADA/elixir/scada_project/scada_master/test_date.csv", [:write, :utf8])
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
