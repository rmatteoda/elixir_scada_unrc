defmodule SCADAMaster.Storage.Importer do
  require Logger

  # Import substations. raise exception if there is substation with the same name and the app won't start
  def import_substations([subconfig | substation_list]) do
    %SCADAMaster.Storage.Substation{}
      |> SCADAMaster.Storage.Substation.changeset(%{name: subconfig.name})
      |> ScadaMaster.Repo.insert!

    import_substations substation_list
  end

  def import_substations([]), do: nil

end