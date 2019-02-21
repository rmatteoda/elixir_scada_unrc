defmodule SCADAMasterTest do
  use ExUnit.Case, async: true
  doctest SCADAMaster

  test "returns nil for not available substation name on DB" do
    assert SCADAMaster.Storage.StorageBind.find_substation_id_by_name("substation_name_not_present") == nil
  end

  test "returns id 1 for first substaiton present in config.exs from substation name (trafo1)" do
    assert SCADAMaster.Storage.StorageBind.find_substation_id_by_name("trafo1") == 1
  end

  test "test invalid changeset for device Map empty" do
    changeset = SCADAMaster.Storage.Device.changeset(%SCADAMaster.Storage.Device{}, %{})   
    assert changeset.valid? == false
  end

  test "test invalid changeset for weather Map empty" do
    changeset = SCADAMaster.Storage.Weather.changeset(%SCADAMaster.Storage.Weather{}, %{})   
    assert changeset.valid? == false
  end

  test "returns celcius value from a :temp in kelvin" do
  	# celcius = kelvin - 273.15
  	{:ok, c_v} = SCADAMaster.Device.WeatherApi.convert(:temp,274.15)
    assert c_v == 1
  end
end
