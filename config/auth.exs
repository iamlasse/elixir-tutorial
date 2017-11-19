use Mix.Config

config :tutorial, Tutorial.Guardian,
       issuer: "Tutorial",
       secret_key: System.get_env("GUARDIAN_SECRET") || "hUmp7tY6Ryfy0prt8pAMOydvt7LQ7faK5qHkmp8O1RyqVIxHyIjSmF48ReYhWxw+"

config :tutorial, Tutorial.AuthAccessPipeline,
  module: Tutorial.Guardian,
  error_handler: Tutorial.AuthErrorHandler