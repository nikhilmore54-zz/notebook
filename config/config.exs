# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :notebook,
  ecto_repos: [Notebook.Repo]

# Configures the endpoint
config :notebook, Notebook.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/GlS/zSAysXgN99vx11Nyhq74gMgn+AGqk5DwbO84ej1cxZOhTsBoGG4aWclQ3LH",
  render_errors: [view: Notebook.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Notebook.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :guardian, Guardian,
  issuer: "Notebook.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Notebook.GuardianSerializer,
  secret_key: to_string(Mix.env) <> "SuPerseCret_aBraCadabrA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
