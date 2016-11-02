
defmodule SCADAMaster.Storage.StorageBind do
  require Logger
  import Ecto.Query
 
  @doc """
  Return substation id from substation name
  """
  def find_substation_id_by_name(substation_name) do
    case ScadaMaster.Repo.get_by(SCADAMaster.Storage.Substation, name: substation_name) do
          %{id: id} -> id
          _ -> nil
    end
  end

  @doc """
  Return all collected data from substation
  """
  def find_collecteddata_by_subid(substation_id) do
    query = from dev in SCADAMaster.Storage.Device,
        where: dev.substation_id == ^substation_id,
        order_by: [asc: :updated_at],
        select: dev

    ScadaMaster.Repo.all(query, log: false)
  end

  @doc """
  Save collected data from substation into device table
  """
  def storage_collected_data(substation_values) do    
    try do
      changeset = SCADAMaster.Storage.Device.changeset(%SCADAMaster.Storage.Device{}, substation_values)
      
      if changeset.valid? do
        Logger.debug "Store device-substations values into DB  "
        ScadaMaster.Repo.insert!(changeset, log: false)
      end

    rescue
      DBConnection.ConnectionError -> Logger.error "storage_collected_data: DBConnection.ConnectionError "
      UndefinedFunctionError -> Logger.error "storage_collected_data: UndefinedFunctionError "
    end
  end

  @doc """
  Save collected data from weather api http://openweathermap.org
  """
  def storage_collected_weather(weather_values) do    
    try do
      changeset = SCADAMaster.Storage.Weather.changeset(%SCADAMaster.Storage.Weather{}, weather_values)
      
      if changeset.valid? do
        Logger.debug "Store weather values into DB  "
        ScadaMaster.Repo.insert!(changeset, log: false)
      end

    rescue
      DBConnection.ConnectionError -> Logger.error "storage_collected_weather: find_substation_by_name DBConnection.ConnectionError "
      UndefinedFunctionError -> Logger.error "storage_collected_weather: UndefinedFunctionError "
    end
  end

end