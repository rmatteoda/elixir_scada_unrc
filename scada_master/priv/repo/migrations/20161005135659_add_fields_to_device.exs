defmodule ScadaMaster.Repo.Migrations.AddFieldsToDevice do
  use Ecto.Migration

  def change do
  	 flush
    alter table(:device) do
      add :totalactivepower, :float
      add :activepower_b, :float
      add :activepower_c, :float
      add :totalreactivepower, :float
      add :reactivepower_c, :float
      add :unbalance_voltage, :float
      add :unbalance_current, :float
    end
  end
end
