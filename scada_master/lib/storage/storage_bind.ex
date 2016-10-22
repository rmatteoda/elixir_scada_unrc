
defmodule SCADAMaster.Storage.StorageBind do
  require Logger

  def dump_substation(substation_name, device) do    
    try do
      found = SCADAMaster.Storage.ScadaQuery.find_substation_by_name(substation_name)  
      substation_db_id = List.first(found).id
            
      Logger.debug "Store device-substations values into DB  "
      ScadaMaster.Repo.insert!(device, log: false)

    rescue
      Ecto.QueryError -> Logger.error "dump_substation: find_substation_by_name Ecto.QueryError "
      DBConnection.ConnectionError -> Logger.error "dump_substation: find_substation_by_name DBConnection.ConnectionError "
      UndefinedFunctionError -> Logger.error "dump_substation: UndefinedFunctionError "
    end
  end

end