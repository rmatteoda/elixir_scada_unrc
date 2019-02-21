defmodule SCADAMaster.Schema.Substation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "substations" do
    has_many :local_measured, SCADAMaster.Schema.MeasuredValues
    field :name, :string

    timestamps()
  end
  
  def changeset(substation, params \\ :empty) do
    substation
    |> cast(params, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end