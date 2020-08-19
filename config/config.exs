use Mix.Config

config :netflex, Netflex.Client, base_path: "https://api.netflexapp.com/v1/"

import_config "#{Mix.env()}.exs"
