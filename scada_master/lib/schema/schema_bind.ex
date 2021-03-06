defmodule SCADAMaster.Schema.StorageBind do
  require Logger
  import Ecto.Query
 
  @doc """
  Return substation id from substation name
  """
  def find_substation_id_by_name(substation_name) do
    case ScadaMaster.Repo.get_by(SCADAMaster.Schema.Substation, name: substation_name) do
          %{id: id} -> id
          _ -> nil
    end
  end

  @doc """
  Return all collected data from substation
  """
  def find_collected_by_subid(substation_id, :all) do
    query = from dev in SCADAMaster.Schema.MeasuredValues,
        where: dev.substation_id == ^substation_id,
        order_by: [asc: :updated_at],
        select: dev

    ScadaMaster.Repo.all(query, log: false)
  end

 @doc """
  Return all collected data from substation for last week
  """
  def find_collected_by_subid(substation_id, :last_week) do
    query = from dev in SCADAMaster.Schema.MeasuredValues,
        where: dev.substation_id == ^substation_id,
        where: dev.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
        order_by: [asc: :updated_at],
        select: dev

    ScadaMaster.Repo.all(query, log: false)
  end

  @doc """
  Return all collected data from substation
  """
  def find_weather_data(:all) do
    query = from weather in SCADAMaster.Schema.Weather,
        order_by: [asc: :updated_at],
        select: weather

    ScadaMaster.Repo.all(query, log: false)
  end

  @doc """
  Return all weather data from last week
  """
  def find_weather_data(:last_week) do
    query = from weather in SCADAMaster.Schema.Weather,
        where: weather.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
        order_by: [asc: :updated_at],
        select: weather

    ScadaMaster.Repo.all(query, log: false)
  end

  @doc """
  Save collected data from substation into measured_valies table
  """
  def storage_collected_data(substation_values) do    
    try do
      changeset = SCADAMaster.Schema.MeasuredValues.changeset(%SCADAMaster.Schema.MeasuredValues{}, substation_values)
      
      if changeset.valid? do
        Logger.debug "Store measured_valies-substations into DB  "
        ScadaMaster.Repo.insert!(changeset, log: false)
      else
        Logger.error "storage_collected_data: error in changset "      
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
      changeset = SCADAMaster.Schema.Weather.changeset(%SCADAMaster.Schema.Weather{}, weather_values)
      if changeset.valid? do
        Logger.debug "Store weather values into DB "
        ScadaMaster.Repo.insert!(changeset, log: false)
      else
        Logger.error "storage_collected_weather: error in changset "      
      end

    rescue
      DBConnection.ConnectionError -> Logger.error "storage_collected_weather: find_substation_by_name DBConnection.ConnectionError "
      UndefinedFunctionError -> Logger.error "storage_collected_weather: UndefinedFunctionError "
      Ecto.InvalidChangesetError -> Logger.error "storage_collected_weather: could not perform insert because changeset is invalid"
    end
  end

end