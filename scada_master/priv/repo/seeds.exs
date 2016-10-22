# Script for populating the database. You can run it as:
#     mix run priv/repo/seeds.exs

defmodule Seeds do
  # Start import - create substations base on config names
  def import_data do
    dev_table = Application.get_env(:scada_master,:device_table)
    import_substations dev_table
  end

  # Import substations
  defp import_substations([subconfig | substation_list]) do
    ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Substation{name: subconfig.name}, log: false)
    import_substations substation_list
  end

  defp import_substations([]), do: nil

end

Seeds.import_data()
