
defmodule SCADAMaster.Storage.StorageBind do
  require Logger

  def dump_substation(substation) do
    substation_name = SCADAMaster.Device.Substation.get(substation,"subname")
    
    found = SCADAMaster.Storage.ScadaQuery.find_substation_by_name(substation_name)  
    substation_db_id = List.first(found).id

    ecto_date = Ecto.Date.local
    Logger.debug "Stora device-substations values into DB  "
    ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Device{devdate: ecto_date, voltage: 2.0, current: 1,substation_id: substation_db_id}, log: false)
  end

end