defmodule SCADAMaster.Storage.Substation do
  use Ecto.Schema
  schema "substations" do
    has_many :local_device, SCADAMaster.Storage.Device
    field :name, :string
  end
  @required_fields ~w(name)
end

defmodule SCADAMaster.Storage.Device do
  use Ecto.Schema
  schema "device" do
    belongs_to :substation, SCADAMaster.Storage.Substation
    field :devdate, Ecto.Date
    field :voltage_a, :float, default: 0.0
    field :voltage_b, :float, default: 0.0
    field :voltage_c, :float, default: 0.0
    field :current_a, :float, default: 0.0
    field :current_a, :float, default: 0.0
    field :current_a, :float, default: 0.0
    field :activepower_a, :float, default: 0.0
    field :reactivepower_a, :float, default: 0.0
    timestamps
  end
end