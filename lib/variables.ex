defmodule Netflex.Variables do
  use GenServer

  def start_link(_ \\ nil), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_) do
    case(refresh_variables()) do
      {:ok, variables} -> {:ok, variables}
      {:error, e} -> {:error, e}
    end
  end

  def refresh(), do: GenServer.cast(__MODULE__, :refresh)
  def list_all(), do: GenServer.call(__MODULE__, :all)
  def list_all(:short), do: GenServer.call(__MODULE__, :get_short)
  def get(key, default \\ nil)
  def get(key, default) when is_atom(key), do: get(Atom.to_string(key), default)

  def get(key, default) when is_bitstring(key) do
    case(GenServer.call(__MODULE__, {:get_alias, key})) do
      nil -> default
      value -> value
    end
  end

  def get(key, default) when is_integer(key) do
    case GenServer.call(__MODULE__, {:get_id, key}) do
      nil -> default
      value -> value
    end
  end

  def handle_cast(:refresh, state) do
    case refresh_variables() do
      {:ok, newState} -> {:noreply, newState}
      {:error, _} -> state
    end
  end

  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_id, alias}, _from, state) do
    {
      :reply,
      Enum.find(state, %{}, &(&1.id == alias))
      |> Map.get(:value, nil),
      state
    }
  end

  def handle_call({:get_alias, alias}, _from, state) do
    {
      :reply,
      Enum.find(state, %{}, &(&1.alias == alias))
      |> Map.get(:value, nil),
      state
    }
  end

  def handle_call(:get_short, _from, state) do
    {:reply,
     Enum.reduce(state, %{}, fn stateElement, payload ->
       payload
       |> Map.put(stateElement.alias, stateElement.value)
     end), state}
  end

  defp refresh_variables do
    IO.puts("Refreshing variables")

    case Netflex.Client.get("foundation/variables") do
      {:ok, %HTTPoison.Response{body: body}} ->
        {:ok,
         body
         |> Enum.map(fn variable ->
           Kernel.struct(Netflex.DataTypes.Variable, variable)
         end)}

      {:error, e} ->
        {:error, e}
    end
  end
end
