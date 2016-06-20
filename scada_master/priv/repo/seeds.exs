# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Simple.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

data = [
    {"Substation 1", [
        {"2016-06-12", 222.3, 5},
        {"2016-06-13", 221.3, 5},
        {"2016-06-13", 221.1, 5},
    ]},
    {"Substation 2", [
        {"2016-06-12", 218.3, 4},
        {"2016-06-13", 219.3, 4},
        {"2016-06-13", 219.1, 4},
    ]},
]

defmodule Seeds do
  # Start import
  def import_data(data) do
    import_substations data
  end

  # Import substations
  defp import_substations([]), do: nil
  defp import_substations([{substation_name,device}|t]) do
    substation = ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Substation{name: substation_name}, log: false)
    import_devices substation, device
    import_substations t
  end

  # Import devices
  defp import_devices(_,[]), do: nil
  defp import_devices(substation, [{devdate,voltage,current}|t]) do
    {:ok, ecto_date} = Ecto.Date.cast(devdate)
    ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Device{devdate: ecto_date, voltage: voltage, current: current,substation_id: substation.id}, log: false)
    import_devices substation, t
  end
end

Seeds.import_data(data)
