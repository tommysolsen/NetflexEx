defmodule Netflex.DataTypes.Variable do
  use Netflex.Mutators.ContentApi,
    integer: [:id, :group],
    boolean: [:visibility]

  defstruct [:alias, :format, :group, :id, :name, :value, :visibility]
end
