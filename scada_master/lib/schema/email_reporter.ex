defmodule SCADAMaster.Schema.EmailReporter do
  use GenServer, restart: :transient
  require Logger

  alias SCADAMaster.Schema.EmailScheme
  alias SCADAMaster.Schema.Mailer
  alias SCADAMaster.Schema.Reporter
   
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.debug "Start Email Reporter " 
    do_schedule_email()
    {:ok, state} 
  end

  def handle_info(:report_email, state) do
    do_report_email()
    # Start the timer again
    do_schedule_email()
    {:noreply, state}
  end
  
  defp do_schedule_email() do
    Process.send_after(self(), :report_email, report_email_after()) 
  end

  #send email with csv tables to fernando magnago
  defp do_report_email do
    substation_list = Application.get_env(:scada_master,:device_table) #save the device_table table configured        
    Reporter.do_report substation_list, :last_week
    do_report_email substation_list
    do_report_email_weather()
  end

  defp do_report_email([subconfig | substation_list]) do
    file_name = Path.join(report_path(), subconfig.name <> "_last_week.csv")
    Logger.debug "Sending email report for substation" <> subconfig.name
    EmailScheme.report(file_name,subconfig.name) |> Mailer.deliver
    do_report_email substation_list
  end

  defp do_report_email([]), do: nil

  defp do_report_email_weather do
    Reporter.do_report_weather(:last_week)
    file_name = Path.join(report_path(), "weather_last_week.csv")
    Logger.debug "Sending email report with weather data"
    EmailScheme.report(file_name,"weather") |> Mailer.deliver
  end

  defp report_email_after do
    Application.get_env(:scada_master, ScadaMaster)
    |> Keyword.fetch!(:report_email_after)
  end

  defp report_path do
    Application.get_env(:scada_master, ScadaMaster)
    |> Keyword.fetch!(:report_path)
  end
end
