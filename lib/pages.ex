defmodule Netflex.Pages do
  use GenServer

  def start_link(_args \\ []), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)
  def init(_), do: refresh_pages()

  def list_all() do
    GenServer.call(__MODULE__, :all)
  end

  def refresh() do
    GenServer.cast(__MODULE__, :refresh)
  end

  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:refresh, state) do
    case refresh_pages() do
      {:ok, newState} -> {:noreply, newState}
      {:error, _} -> {:noreply, state}
    end
  end

  defp refresh_pages() do
    case Netflex.Client.get("builder/pages") do
      {:ok, %HTTPoison.Response{body: body}} ->
        {:ok,
         body
         |> Enum.map(&struct(Netflex.DataTypes.Page, &1))}

      {:error, e} ->
        {:error, e}
    end
  end
end
