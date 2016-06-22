# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# configure ip of diferent device connected to substation to be monitored.
config :scada_master, :device_table,
       [%{ip: "192.168.0.106", name: "trafo1"},
       %{ip: "192.168.0.107", name: "trafo2"}]

# configure the register to be read for each device (reference values from sempron ).
config :scada_master, :register_table,
       [{:v, "1"},
        {:l, "3"},
        {:i, "5"}]

config :scada_master,
  ecto_repos: [ScadaMaster.Repo]

import_config "#{Mix.env}.exs"
