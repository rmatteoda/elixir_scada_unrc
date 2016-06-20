# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
data = []

defmodule Seeds do
  # Start import - create substations base on config names
  def import_data(data) do
    dev_table = Application.get_env(:scada_master,:device_table)
    Enum.each(dev_table, fn(subconfig) -> 
      import_substations(subconfig.name)
    end)
    #import_substations data
  end

  # Import substations
  defp import_substations(substation_name) do
    ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Substation{name: substation_name}, log: false)
  end

  # defp import_substations([]), do: nil
  # defp import_substations([{substation_name,device}|t]) do
  #   substation = ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Substation{name: substation_name}, log: false)
  #   import_devices substation, device
  #   import_substations t
  # end

  # Import devices
  # defp import_devices(_,[]), do: nil
  # defp import_devices(substation, [{devdate,voltage,current}|t]) do
  #   {:ok, ecto_date} = Ecto.Date.cast(devdate)
  #   ScadaMaster.Repo.insert!(%SCADAMaster.Storage.Device{devdate: ecto_date, voltage: voltage, current: current,substation_id: substation.id}, log: false)
  #   import_devices substation, t
  # end
end

Seeds.import_data(data)
