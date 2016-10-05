
defmodule SCADAMaster.Storage.ScadaQuery do
  import Ecto.Query
  
  def find_substation_by_name(substation_name) do
    query = from sb in SCADAMaster.Storage.Substation,
        where: sb.name == ^substation_name,
        select: sb

	ScadaMaster.Repo.all(query, log: false)
  end

  def find_collecteddata_by_subid(substation_id) do
    query = from dev in SCADAMaster.Storage.Device,
        where: dev.substation_id == ^substation_id,
        order_by: [asc: :devdate],
        select: dev

	ScadaMaster.Repo.all(query, log: false)
  end

end