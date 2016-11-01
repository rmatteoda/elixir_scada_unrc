defmodule SCADAMaster.Device.WeatherApi do

require Logger

@weather_uri "http://api.openweathermap.org/data/2.5/weather?q=Rio%20Cuarto&appid=9f93848b56f03956ac309647a7132103"

  @doc """
  Call api to get weather info of Rio Cuarto using http://api.openweathermap.org
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

  defp do_process_response(weather_json_body) do 
    IO.puts weather_json_body
    weather_json_body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
    
  end

end

# {"coord":{"lon":-64.35,"lat":-33.13},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],
# "base":"stations","main":{"temp":290.15,"pressure":1012,"humidity":29,"temp_min":290.15,"temp_max":290.15},
# "visibility":10000,"wind":{"speed":13.9,"deg":180,"gust":20.6},"clouds":{"all":0},"dt":1478030400,"sys":
# {"type":1,"id":4715,"message":0.0024,"country":"AR","sunrise":1477991805,"sunset":1478040335},"id":3838874,
# "name":"Rio Cuarto","cod":200}

