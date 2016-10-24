
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
        order_by: [asc: :devdate],
        select: dev

    ScadaMaster.Repo.all(query, log: false)
  end

  @doc """
  Save collected data from substation into device table
  """
  def storage_collected_data(device) do    
    try do
      Logger.debug "Store device-substations values into DB  "
      ScadaMaster.Repo.insert!(device, log: false)
    rescue
      Ecto.QueryError -> Logger.error "dump_substation: find_substation_by_name Ecto.QueryError "
      DBConnection.ConnectionError -> Logger.error "dump_substation: find_substation_by_name DBConnection.ConnectionError "
      UndefinedFunctionError -> Logger.error "dump_substation: UndefinedFunctionError "
    end
  end

end