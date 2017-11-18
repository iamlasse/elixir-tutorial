# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tutorial, ecto_repos: [Tutorial.Repo]

# Configures the endpoint
config :tutorial, TutorialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nn1T3N4wAXLzZwdKZWSjfAuLPVuarnt6R7TcIPiD765w+vi+zeP1pgBsiHbW+0ni",
  render_errors: [view: TutorialWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tutorial.PubSub,
           adapter: Phoenix.PubSub.PG2]

# config :tutorial, TutorialWeb.Endpoint,
#   url: [host: "localhost"],
#   secret_key_base: "nn1T3N4wAXLzZwdKZWSjfAuLPVuarnt6R7TcIPiD765w+vi+zeP1pgBsiHbW+0ni",
#   render_errors: [view: TutorialWeb.ErrorView, accepts: ~w(html json)],
#   pubsub: [
#     name: Tutorial.PubSub,
#     adapter: Phoenix.PubSub.Redis,
#     host: "localhost",
#     # port: 32775,
#     node_name: "hello"
#   ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"