defmodule SCADAMaster.Storage.Substation do
  use Ecto.Schema
  schema "substations" do
    has_many :local_device, SCADAMaster.Storage.Device
    field :name, :string
  end
end

defmodule SCADAMaster.Storage.Device do
  use Ecto.Schema
  schema "device" do
    belongs_to :substation, SCADAMaster.Storage.Substation
    field :devdate, Ecto.Date
    field :voltage, :float, default: 0.0
    field :current, :integer, default: 0
    timestamps
  end
end