# SCADAMaster

## Dependencies
The project needs elixir 1.2, Postgresql >= 9

## Initial setup

check configuration under /config
  - define the postgres database credentials
  - define the IP addess and name of the substations

run `make setup` to install
run `mix do ecto.reset` to reset the DB and seed initial data
all dependencies and perform the initial setup steps.

## Run tests

`make test`

## Create docs

`make docs`

## Run dialyzer

`make dialyzer`

# Build a release

`make release`
