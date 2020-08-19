defmodule Netflex.Application do
  use Application

  def start(_, _) do
    IO.puts("Starting Netflex engine")

    Supervisor.start_link(
      [
        Netflex.Variables,
        Netflex.Templates
      ],
      strategy: :one_for_one
    )
  end
end
