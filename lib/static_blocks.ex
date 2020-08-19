defmodule Netflex.StaticBlocks do
  use GenServer

  alias Netflex.DataTypes.{StaticBlock, StaticBlockGlobal}
  def start_link(_args \\ nil), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_) do
    refresh_static_blocks()
  end

  def list_all do
    GenServer.call(__MODULE__, :all)
  end

  def get(block, global) when is_atom(block), do: get(Atom.to_string(block), global)
  def get(block, global) when is_atom(global), do: get(block, Atom.to_string(global))
  def get(block, global), do: GenServer.call(__MODULE__, {:get_alias, block, global})

  def refresh() do
    GenServer.cast(__MODULE__, :refresh)
  end

  def handle_cast(:refresh, state) do
    case refresh_static_blocks() do
      {:ok, newState} -> {:noreply, newState}
      {:error, _} -> state
    end
  end

  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_alias, block, global}, _from, state) do
    {
      :reply,
      Enum.find(state, %{globals: []}, &(&1.alias == block)).globals
      |> Enum.find(nil, &(&1.alias == global))
      |> StaticBlockGlobal.get_content(),
      state
    }
  end

  defp refresh_static_blocks() do
    case Netflex.Client.get("foundation/globals") do
      {:ok, %HTTPoison.Response{body: body}} ->
        {
          :ok,
          body
          |> Enum.map(&struct(Netflex.DataTypes.StaticBlock, &1))
          |> Enum.map(&Netflex.DataTypes.StaticBlock.struct_globals/1)
        }

      {:error, _} = e ->
        e
    end
  end
end
