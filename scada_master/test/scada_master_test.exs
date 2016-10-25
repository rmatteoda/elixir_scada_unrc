defmodule SCADAMasterTest do
  use ExUnit.Case, async: true
  doctest SCADAMaster

  test "returns nil for not available substation name on DB" do
    assert SCADAMaster.Storage.StorageBind.find_substation_id_by_name("substation_name_not_present") == nil
  end

  test "returns id 1 for first substaiton present in config.exs from substation name (trafo1)" do
    assert SCADAMaster.Storage.StorageBind.find_substation_id_by_name("trafo1") == 1
  end
end
