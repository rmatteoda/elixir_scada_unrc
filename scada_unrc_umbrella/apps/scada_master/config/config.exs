# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# configure ip of diferent device connected to substation to be monitored.
config :scada_master, :device_table,
       [sub1: %{ip: "192.168.0.106", name: "trafo1"},
        sub2: %{ip: "192.168.0.107", name: "trafo2"}]

# configure the register to be read for each device (reference values from sempron ).
config :scada_master, :register_table,
       [{:v, "1"},
        {:l, "3"},
        {:i, "5"}]

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :scada_master, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:scada_master, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#import_config "#{Mix.env}.exs"
