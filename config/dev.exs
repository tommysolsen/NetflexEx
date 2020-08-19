use Mix.Config

if File.exists?("config/dev.credentials.exs"), do: import_config("#{Mix.env()}.credentials.exs")
