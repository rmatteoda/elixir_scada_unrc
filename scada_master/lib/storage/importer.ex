defmodule SCADAMaster.Storage.Importer do
  require Logger

  # Import substations
  def import_substations([subconfig | substation_list]) do
    case ScadaMaster.Repo.get_by(SCADAMaster.Storage.Substation, name: subconfig.name) do
          nil -> insert(subconfig)
          _ -> nil
    end
    import_substations substation_list
  end

  def import_substations([]), do: nil

  defp insert(subconfig) do
    ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Substation{name: subconfig.name}, log: false)
  end

end