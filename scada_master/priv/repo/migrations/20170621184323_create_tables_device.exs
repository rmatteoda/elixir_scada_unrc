defmodule ScadaMaster.Repo.Migrations.CreateTablesDevice do
#defmodule Repo.CreateTables do
  use Ecto.Migration

  def up do
    #substation has a unique name for now
    create table(:substations) do
      add :name, :string, size: 40, null: false, unique: true
    end

    # device belong to a substation
    create table(:device) do
      add :substation_id, references(:substations)
      add :voltage_a,   :float
      add :voltage_b,   :float
      add :voltage_c,   :float
      add :current_a, :float
      add :current_b, :float
      add :current_c, :float
      add :activepower_a, :float
      add :activepower_b, :float
      add :activepower_c, :float
      add :reactivepower_a, :float
      add :reactivepower_b, :float
      add :reactivepower_c, :float
      add :totalactivepower, :float
      add :totalreactivepower, :float
      add :unbalance_voltage, :float
      add :unbalance_current, :float
      timestamps
    end

    # We also add an index so we can find substations
    create index(:device, [:substation_id])

    create unique_index(:substations, [:name], name: :unique_names)

    #we save the weather data from openweather api
    create table(:weather) do
      add :temp, :float
      add :humidity,   :float
      add :pressure,   :float
      add :wind_speed, :float
      add :cloudiness, :string
      timestamps
    end

  end

  def down do
    drop index(:device, [:substation_id])
    drop table(:substations)
    drop table(:weather)
  end
end

