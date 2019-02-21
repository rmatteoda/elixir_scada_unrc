defmodule SCADAMaster.Schema.Importer do
  require Logger
  alias SCADAMaster.Schema.Substation

  # Import substations. 
  def import_substations([subconfig | substation_list]) do
	  try do
	    %Substation{} |> Substation.changeset(%{name: subconfig.name}) |> ScadaMaster.Repo.insert(log: false)
    rescue
      DBConnection.ConnectionError ->
        Logger.error "import_substations: Database is down"
    end

    import_substations substation_list    
  end

  def import_substations([]), do: nil

end