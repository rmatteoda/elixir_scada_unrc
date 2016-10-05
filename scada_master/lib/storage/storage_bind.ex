
defmodule SCADAMaster.Storage.StorageBind do
  require Logger

  def dump_substation(substation) do    
    try do

      substation_name = SCADAMaster.Device.Substation.get(substation,"name")
      found = SCADAMaster.Storage.ScadaQuery.find_substation_by_name(substation_name)  
      
      substation_db_id = List.first(found).id
      
      collected_time = Ecto.DateTime.utc
      
      substation_voltage_a = SCADAMaster.Device.Substation.get(substation,"voltage_a")
      substation_voltage_b = SCADAMaster.Device.Substation.get(substation,"voltage_b")
      substation_voltage_c = SCADAMaster.Device.Substation.get(substation,"voltage_c")
      substation_current_a = SCADAMaster.Device.Substation.get(substation,"current_a")
      substation_current_b = SCADAMaster.Device.Substation.get(substation,"current_b")
      substation_current_c = SCADAMaster.Device.Substation.get(substation,"current_c")
      substation_actpower_a = SCADAMaster.Device.Substation.get(substation,"actpower_a")
      substation_actpower_b = SCADAMaster.Device.Substation.get(substation,"actpower_b")
      substation_actpower_c = SCADAMaster.Device.Substation.get(substation,"actpower_c")
      substation_reactpower_a = SCADAMaster.Device.Substation.get(substation,"reactpower_a")
      substation_reactpower_b = SCADAMaster.Device.Substation.get(substation,"reactpower_b")
      substation_reactpower_c = SCADAMaster.Device.Substation.get(substation,"reactpower_c")
      substation_totalactpower = SCADAMaster.Device.Substation.get(substation,"totalactpower")
      substation_totalreactpower = SCADAMaster.Device.Substation.get(substation,"totalreactpower")
      substation_unbalance_v = SCADAMaster.Device.Substation.get(substation,"unbalance_v")
      substation_unbalance_c = SCADAMaster.Device.Substation.get(substation,"unbalance_c")
      
      Logger.debug "Store device-substations values into DB  "
      ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Device{devdate: collected_time, 
                                voltage_a: substation_voltage_a, 
                                voltage_b: substation_voltage_b, 
                                voltage_c: substation_voltage_c, 
                                current_a: substation_current_a,
                                current_b: substation_current_b,
                                current_c: substation_current_c,
                                activepower_a: substation_actpower_a,
                                activepower_b: substation_actpower_b,
                                activepower_c: substation_actpower_c,
                                reactivepower_a: substation_reactpower_a,
                                reactivepower_b: substation_reactpower_b,
                                reactivepower_c: substation_reactpower_c,
                                totalactivepower: substation_totalactpower,
                                totalreactivepower: substation_totalreactpower,
                                unbalance_voltage: substation_unbalance_v,
                                unbalance_current: substation_unbalance_c,
                                substation_id: substation_db_id}, log: false)
    rescue
      Ecto.QueryError -> Logger.error "dump_substation: find_substation_by_name Ecto.QueryError "
      DBConnection.ConnectionError -> Logger.error "dump_substation: find_substation_by_name DBConnection.ConnectionError "
      UndefinedFunctionError -> Logger.error "dump_substation: UndefinedFunctionError "
    end
  end

end