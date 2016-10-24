
defmodule SCADAMaster.Storage.ScadaQuery do
  import Ecto.Query
  
  @doc """
  Return substation id from substation name
  """
  def find_substation_id_by_name(substation_name) do
    case ScadaMaster.Repo.get_by(SCADAMaster.Storage.Substation, name: substation_name, log: false) do
          %{id: id} -> id
          _ -> nil
    end
  end

  @doc """
  Return all collected data from substation
  """
  def find_collecteddata_by_subid(substation_id) do
    query = from dev in SCADAMaster.Storage.Device,
        where: dev.substation_id == ^substation_id,
        order_by: [asc: :devdate],
        select: dev

	  ScadaMaster.Repo.all(query, log: false)
  end

end