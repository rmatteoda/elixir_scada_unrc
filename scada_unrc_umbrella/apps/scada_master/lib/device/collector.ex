defmodule SCADAMaster.Device.Collector do

  use GenServer
  require Logger

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  ## Server Callbacks
  def init(:ok) do
    dev_table = Application.get_env(:scada_master,:device_table) #save the device table configured
    reg_table  = Application.get_env(:scada_master,:register_table) #save the registrer table configured
    {:ok, {dev_table, reg_table}}
  end

  def handle_call({:lookup, name}, _from, {names, _} = state) do
  end

  def handle_cast({:create, name}, {names, refs}) do
  end

end
