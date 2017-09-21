defmodule SCADAMaster.Schema.Reporter do
  use GenServer, restart: :transient
  require Logger

  alias SCADAMaster.Schema.StorageBind

# configure time in ms to collect data from scada devies.
  # The time of a report can be set with:
  #`config :scada_master, ScadaMaster, report_after: 1000`
  
  #the path to save the report csv file can be set with:
  #config: report_path "/Users/rammatte/Workspace/UNRC/SCADA/elixir/scada_project/scada_master/"
  
  #column names array for reports
  @weather_header ["Temperatura", "Presion", "Humedad", "Date"]
  @meassured_header ["Substation Name", 
                    "Voltage A", "Voltage B", "Voltage C",
                    "Current A", "Current B", "Current C",
                    "Active Power A", "Active Power B", "Active Power C",
                    "Reactive Power A", "Reactive Power B", "Reactive Power C",
                    "Total Active Power", "Total Reactive Power",
                    "Unbalance Voltage", "Unbalance Current", 
                    "Date"]
 
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.debug "Start Reporter " 
    do_schedule()
    {:ok, state} 
  end

  def handle_info(:report, state) do
    report()
    # Start the timer again
    do_schedule()
    {:noreply, state}
  end

  defp do_schedule() do
    Process.send_after(self(), :report, report_after()) 
  end
  
  @doc """
  for each substation report into a csv file all data collected
  """
  def report() do
    # get the table configured with all substation ips
    substation_list = Application.get_env(:scada_master,:device_table) #save the device_table table configured        
    do_report substation_list

    #report weather data
    do_report_weather()
  end

  defp do_report([subconfig | substation_list]) do
    case StorageBind.find_substation_id_by_name(subconfig.name) do 
      nil -> Logger.error "Substation not found in DB to generate report"
      sub_id -> dev_table_result = StorageBind.find_collecteddata_by_subid(sub_id)
                do_report_table(dev_table_result,subconfig.name)
    end

    do_report substation_list
  end

  defp do_report([]), do: nil

  @doc """
  made a query to db and get all values of substation
  dump values into csv file report
  """
  def do_report_table(dev_table_result, substation_name) do
    file_name = Path.join(report_path(), substation_name <> "_data.csv")
    f = File.open!(file_name, [:write, :utf8])

    IO.write(f, CSVLixir.write_row(@meassured_header))
    
    Enum.each(dev_table_result, fn(measured_values) -> 
      #{:ok, datetime} = DateTime.from_naive(measured_values.inserted_at)
      IO.write(f, CSVLixir.write_row([substation_name,
                                      measured_values.voltage_a, measured_values.voltage_b, measured_values.voltage_c,
                                      measured_values.current_a, measured_values.current_b, measured_values.current_c,
                                      measured_values.activepower_a, measured_values.activepower_b, measured_values.activepower_c,
                                      measured_values.reactivepower_a, measured_values.reactivepower_b, measured_values.reactivepower_c,
                                      measured_values.totalactivepower,measured_values.totalreactivepower,
                                      measured_values.unbalance_voltage,measured_values.unbalance_current,
                                      NaiveDateTime.to_string(measured_values.inserted_at)]))
    end)  
    
    File.close(f)
  end

  defp do_report_weather() do
    weather_table = StorageBind.find_weather_data()
    
    file_name = Path.join(report_path(), "weather_data.csv")
    f = File.open!(file_name, [:write, :utf8])

    IO.write(f, CSVLixir.write_row(@weather_header))
  
    Enum.each(weather_table, fn(weather) -> 
      IO.write(f, CSVLixir.write_row([weather.temp,
                                      weather.pressure, 
                                      weather.humidity,
                                      NaiveDateTime.to_string(weather.inserted_at)]))
    end)  
    
    File.close(f)
  end

  defp report_after do
    Application.get_env(:scada_master, ScadaMaster)
    |> Keyword.fetch!(:report_after)
  end

  defp report_path do
    Application.get_env(:scada_master, ScadaMaster)
    |> Keyword.fetch!(:report_path)
  end
end
