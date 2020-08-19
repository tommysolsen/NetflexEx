defmodule Netflex.DataTypes.StaticBlock do
  use Netflex.Mutators.ContentApi,
    integer: [:id]

  defstruct [:id, :name, :alias, :globals]

  def struct_globals(%__MODULE__{globals: globals} = struct) do
    Map.put(
      struct,
      :globals,
      globals
      |> Enum.map(&struct(Netflex.DataTypes.StaticBlockGlobal, &1))
      |> Enum.map(&Netflex.Mutator.decode/1)
    )
  end
end
