defmodule SCADAMaster.Mixfile do
  use Mix.Project

  def project do
    [app: :scada_master,
     version: "0.0.1",
     elixir: "~> 1.2",
     deps: deps,
     aliases: aliases,
     escript: [main_module: SCADAMaster.Main]]
  end

  # Configuration for the OTP application
  # Type "mix help compile.app" for more information
  def application do
    [mod: {SCADAMaster, []},
     applications: [:postgrex, :ecto, :logger, :logger_file_backend]]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test":       ["ecto.reset", "test"]]
  end

  # Dependencies can be Hex packages:
  #   {:mydep, "~> 0.3.0"}
  defp deps do
    [{:ex_modbus, git: "https://github.com/jwarwick/ex_modbus.git"},
     {:postgrex, ">= 0.0.0"},
     {:ecto, ">= 0.0.0"},
     {:logger_file_backend, ">= 0.0.4"}]
  end
end
