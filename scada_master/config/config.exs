# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# General application configuration
config :scada_master,
  ecto_repos: [ScadaMaster.Repo]

# configure ip of diferent device connected to substation to be monitored.
config :scada_master, :device_table,
       [%{ip: "192.168.0.5", name: "sub_anf"},
   		%{ip: "192.168.0.6", name: "sub_jardin"}]

# logger configuration 
config :logger,
  backends: [{LoggerFileBackend, :debug},
             {LoggerFileBackend, :error}]

config :logger, :debug,
  path: "log/debug.log",
  level: :debug

config :logger, :error,
  path: "log/error.log",
  level: :error

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
