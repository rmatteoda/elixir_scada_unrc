defmodule Repo.CreateTables do
  use Ecto.Migration

  def up do
    create table(:device) do
      add :substation_id, :integer
      add :devdate,   :date
      add :voltage,   :float
      add :current, :integer
      timestamps
    end
    create index(:device, [:substation_id])

    create table(:substations) do
      add :name, :string, size: 40, null: false, unique: true
    end

    create unique_index(:substations, [:name], name: :unique_names)
  end

  def down do
    drop index(:device, [:substation_id])
    drop table(:substations)
  end
end
