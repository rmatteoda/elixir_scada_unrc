defmodule SCADAMaster.Schema.MeasuredValues do
  use Ecto.Schema
  import Ecto.Changeset

  schema "measured_values" do
    belongs_to :substation, SCADAMaster.Schema.Substation
    field :voltage_a, :float, default: 0.0
    field :voltage_b, :float, default: 0.0
    field :voltage_c, :float, default: 0.0
    field :current_a, :float, default: 0.0
    field :current_b, :float, default: 0.0
    field :current_c, :float, default: 0.0
    field :activepower_a, :float, default: 0.0
    field :activepower_b, :float, default: 0.0
    field :activepower_c, :float, default: 0.0
    field :reactivepower_a, :float, default: 0.0
    field :reactivepower_b, :float, default: 0.0
    field :reactivepower_c, :float, default: 0.0
    field :totalactivepower, :float, default: 0.0
    field :totalreactivepower, :float, default: 0.0
    field :unbalance_voltage, :float, default: 0.0
    field :unbalance_current, :float, default: 0.0
    
    timestamps()
  end

  @required_fields [:voltage_a, :voltage_b, :voltage_c, :current_a, :current_b, :current_c, :substation_id]
  @optional_fields [:activepower_a, :activepower_b, :activepower_c, :reactivepower_a, :reactivepower_b, 
  :reactivepower_c, :totalactivepower, :totalreactivepower, :unbalance_voltage, :unbalance_current]

  def changeset(measured_value, params \\ :empty) do
    measured_value
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end
end