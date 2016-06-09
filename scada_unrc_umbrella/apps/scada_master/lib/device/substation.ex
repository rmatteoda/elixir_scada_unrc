defmodule SCADAMaster.Device.Substation do

 require Logger

 @doc """
  Starts a 
  """
  def start_link(substation_name) do
    Agent.start_link(fn -> [] end, name: substation_name)
  end

  @doc """
  Get the data currently in the `TABLE`.
  """
  def get(substation) do
    Agent.get(substation, fn list -> list end)
  end

  @doc """
  Pushes `value` into the door.
  """
  def push(substation, value) do
    Agent.update(substation, fn list -> [value|list] end)
  end

  @doc """
  Pops a value from the `CONNECTOR`.

  Returns `{:ok, value}` if there is a value
  or `:error` if the hole is currently empty.
  """
  def pop(substation) do
    Agent.get_and_update(substation, fn
      []    -> {:error, []}
      [h|t] -> {{:ok, h}, t}
    end)
  end
end