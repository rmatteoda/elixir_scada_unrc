defmodule SCADAMaster.Storage.Substation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "substations" do
    has_many :local_device, SCADAMaster.Storage.Device
    field :name, :string
  end
  
  def changeset(substation, params \\ :empty) do
    substation
    |> cast(params, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end

defmodule SCADAMaster.Storage.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "device" do
    belongs_to :substation, SCADAMaster.Storage.Substation
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

  @required_fields ~w(voltage_a voltage_b voltage_c 
                      current_a current_b current_c 
                      substation_id)
  @optional_fields ~w(activepower_a activepower_b activepower_c 
                      reactivepower_a reactivepower_b reactivepower_c 
                      totalactivepower totalreactivepower 
                      unbalance_voltage unbalance_current)

  def changeset(device, params \\ :empty) do
    device
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end
end

defmodule SCADAMaster.Storage.Weather do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weather" do
    field :temp, :float
    field :humidity, :float
    field :pressure, :float
    field :wind_speed, :float
    field :cloudiness, :string
    timestamps()
  end

  @required_fields ~w(humidity pressure temp)
  @optional_fields ~w(cloudiness wind_speed)

  def changeset(weather, params \\ :empty) do
    weather
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end

end