# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# General application configuration
config :scada_master,
  ecto_repos: [ScadaMaster.Repo]

# configure ip of diferent device connected to substation to be monitored.
config :scada_master, :device_table,
      [%{ip: "192.168.0.5", name: "sub_anf"}]

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

#config time for to collect data from substations (recommended 10 minutes)
config :scada_master, ScadaMaster,
  collect_each: 1000 * 60 * 10 # 10 minutes

#config time to save data into csv file (recomended 2 hours)
config :scada_master, ScadaMaster,
  report_after: 1000 * 60 * 120 # 120 minutes

#config time to send email report with csv file (recomended 12 hours)
config :scada_master, ScadaMaster,
  report_email_after: 1000 * 60 * 720 # 12 horas

config :scada_master, ScadaMaster,
  report_path: "/Users/rammatte/Workspace/UNRC/SCADA/elixir/scada_project/scada_master/" 

# Config Email Adapter
config :scada_master, SCADAMaster.Schema.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smtp.gmail.com",
  port: 587,
  username: "metodosunrc@gmail.com",
  password: "novalematlab",
  tls: :always,
  auth: :always
         
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
