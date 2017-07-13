defmodule SCADAMaster.Device.WeatherAccess do
require Logger
alias SCADAMaster.Schema.StorageBind

@weather_uri "http://api.openweathermap.org/data/2.5/weather?q=Rio%20Cuarto&appid=9f93848b56f03956ac309647a7132103"
@expected_fields ~w(weather wind main )

  @doc """
  Call api to get weather info of Rio Cuarto using http://openweathermap.org
  """
  def collect_weather do
    case HTTPoison.get(@weather_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        do_process_response body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.error "Weather API Call error: URI Not found "
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Weather API Call error: #{reason}"
    end
  end

  #TODO add try rescue for parse!?
  defp do_process_response(weather_json_response) do 
    weather_json_response 
    |> Poison.Parser.parse! 
    |> Map.take(@expected_fields) 
    |> do_save_weather
  end

  defp do_save_weather(weather_map) do 
    Enum.map(weather_map["main"], fn {key, val} -> convert(String.to_atom(key),val) end) 
    |> Map.new 
    |> StorageBind.storage_collected_weather
  end
  
  @doc """
  Convert weather values from api to local standars (i.e: convert :temp from kelvin to celcius)
  """
  def convert(k, v) do
    do_convert(k,v)
  end

  defp do_convert(:temp, kelvin_v), do: {:temp, kelvin_v - 273.15}
  defp do_convert(k, v), do: {k,v}
end
