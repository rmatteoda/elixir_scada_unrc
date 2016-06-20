
defmodule SCADAMaster.Storage.StorageBind do
  require Logger

  def dump_substation(substation) do
    substation_name = SCADAMaster.Device.Substation.get(substation,"name")
    
    found = SCADAMaster.Storage.ScadaQuery.find_substation_by_name(substation_name)  
    substation_db_id = List.first(found).id

    collected_day = Ecto.Date.utc
    substation_voltage = SCADAMaster.Device.Substation.get(substation,"voltage")
    substation_current = SCADAMaster.Device.Substation.get(substation,"current")
    
    Logger.debug "Stora device-substations values into DB  "
    ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Device{devdate: collected_day, voltage: substation_voltage, 
                            current: substation_current,substation_id: substation_db_id}, log: false)
  end

end