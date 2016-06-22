
defmodule SCADAMaster.Storage.ScadaQuery do
  import Ecto.Query
  
  def find_substation_by_name(substation_name) do
    query = from sb in SCADAMaster.Storage.Substation,
        where: sb.name == ^substation_name,
        select: sb

	ScadaMaster.Repo.all(query, log: false)
  end

end