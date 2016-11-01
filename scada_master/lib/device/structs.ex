defmodule SCADAMaster.Device.SubstationStruct do
@doc """
Define struct for senpron with register keys and offset to read using modbus
"""
  defstruct voltage_a: 1,
            voltage_b: 3,
            voltage_c: 5,
            current_a: 13,
            current_b: 15,
            current_c: 17,
            activepower_a: 25,
            activepower_b: 27,
            activepower_c: 29,
            reactivepower_a: 31,
            reactivepower_b: 33,
            reactivepower_c: 35,
            totalactivepower: 65,
            totalreactivepower: 67,
            unbalance_voltage: 71,
            unbalance_current: 73
end
  