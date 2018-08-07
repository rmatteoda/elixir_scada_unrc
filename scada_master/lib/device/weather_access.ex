defmodule SCADAMaster.Device.WeatherAccess do
require Logger
alias SCADAMaster.Schema.StorageBind

# can set the api weather url in config file?
# @consumer_key Application.get_env(:noun_projex, :api_key)

# openweathermap (da algunas veces datos erroneos)
# @weather_uri "http://api.openweathermap.org/data/2.5/weather?q=Rio%20Cuarto&appid=9f93848b56f03956ac309647a7132103"
# @expected_fields ~w(weather wind main )

#nueva weather api usando apixu
@weather_uri "http://api.apixu.com/v1/current.json?key=5be949e243154ac4af8154311180708&q=Rio%20Cuarto"
@expected_fields ~w(current)

  @doc """
  Call api to get weather info of Rio Cuarto using http://openweathermap.org
  """
  def collect_weather do
    Logger.debug "Collecting weather data " 
    
    case HTTPoison.get(@weather_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        do_process_response body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        do_save_weather_on_error()
        Logger.error "Weather API Call error: URI Not found "
      {:error, %HTTPoison.Error{reason: reason}} ->
        do_save_weather_on_error()
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
    Enum.map(weather_map["current"], fn {key, val} -> convert(String.to_atom(key),val) end) 
    |> Map.new 
    |> StorageBind.storage_collected_weather
  end
  
  #save weather with 0 when there is a connection error
  defp do_save_weather_on_error do    
    StorageBind.storage_collected_weather(%{humidity: 0, pressure: 0, temp: 0})
  end

  @doc """
  Convert weather values from api to local standars (i.e: convert :temp from kelvin to celcius)
  """
  def convert(k, v) do
    do_convert(k,v)
  end

  defp do_convert(:temp_c, v), do: {:temp, v}
  defp do_convert(:pressure_mb, v), do: {:pressure, v}
  defp do_convert(k, v), do: {k,v}
end
