defmodule SCADAMaster.Schema.Weather do
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