use Mix.Config

config :netflex, Netflex.Client, base_path: "https://api.netflexapp.com/v1/"

import_config "#{Mix.env()}.exs"

if File.exists?("config/#{Mix.env()}.credentials.exs"),
  do: import_config("#{Mix.env()}.credentials.exs")
