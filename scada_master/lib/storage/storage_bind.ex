
defmodule SCADAMaster.Storage.StorageBind do
  require Logger

  def dump_substation(device) do    
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