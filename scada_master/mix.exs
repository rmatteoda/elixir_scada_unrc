defmodule SCADAMaster.Mixfile do
  use Mix.Project

  def project do
    [app: :scada_master,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases(),
     docs: [main: "readme",
            extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  # Type "mix help compile.app" for more information
  def application do
    [mod: {SCADAMaster.Application, []},
     applications: [:postgrex, :ecto, :logger, :logger_file_backend, :ex_modbus, :httpoison]]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "ecto.test":  ["ecto.create --quiet", "ecto.migrate", "test"]]
  end

  # Dependencies can be Hex packages:
  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:ex_modbus, git: "https://github.com/jwarwick/ex_modbus.git"},
     {:postgrex, ">= 0.0.0"},
     {:ecto, ">= 1.1.8"},
     {:logger_file_backend, ">= 0.0.4"},
     {:exrm, "~> 1.0.8"},
     {:csvlixir, "~> 2.0.3"},
     {:httpoison, "~> 0.9.0"},
     {:poison, "~> 2.0"}]
  end
end
