defmodule SCADAMaster.Device.Substation do

  @doc """
  Starts a 
  """
  # def start_link(substation_name,substation_ip) do
  #   Agent.start_link(fn -> %{} end, name: substation_name, ip: substation_ip)
  # end
  
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Get the data currently in the `TABLE`.
  """
  def get(substation, key) do
     Agent.get(substation, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def put(substation, key, value) do
    Agent.update(substation, &Map.put(&1, key, value))
  end

  @doc """
  Deletes `key` from `bucket`.
  Returns the current value of `key`, if `key` exists.
  """
  def delete(substation, key) do
    Agent.get_and_update(substation, fn dict->
      Map.pop(dict, key)
    end)
  end
end