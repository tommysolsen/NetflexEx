defmodule Netflex.Templates do
  use GenServer

  alias Netflex.DataTypes.{Template}

  def start_link(_ \\ nil) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    case refresh_templates() do
      {:ok, newState} -> {:ok, newState}
      {:error, e} -> {:error, e}
    end
  end

  def get(templateAlias) when is_atom(templateAlias) do
    get(Atom.to_string(templateAlias))
  end

  def get(templateAlias) when is_bitstring(templateAlias) do
    GenServer.call(__MODULE__, {:template_alias, templateAlias})
  end

  def handle_call({:template_alias, alias}, _from, state) do
    {:reply,
     Enum.find(state, fn
       %Template{alias: ^alias} -> true
       _ -> false
     end), state}
  end

  def refresh, do: GenServer.cast(__MODULE__, :refresh)

  def handle_cast(:refresh, state) do
    case refresh_templates() do
      {:ok, newState} -> {:noreply, newState}
      {:error, _e} -> {:noreply, state}
    end
  end

  defp refresh_templates do
    IO.puts("Refreshing templates")

    case Netflex.Client.get("foundation/templates") do
      {:ok, %HTTPoison.Response{body: body}} ->
        {:ok,
         body
         |> Enum.map(fn
           %{type: "page"} = pl -> Kernel.struct(Template, pl)
           _ -> nil
         end)
         |> Enum.reject(&(&1 == nil))
         |> Enum.map(&Netflex.DataTypes.Template.convert_config/1)}

      {:error, e} ->
        {:error, e}
    end
  end
end
