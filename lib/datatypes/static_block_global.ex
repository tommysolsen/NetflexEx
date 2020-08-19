defmodule Netflex.DataTypes.StaticBlockGlobal do
  use Netflex.Mutators.ContentApi,
    integer: [:id],
    boolean: [:has_subpages, :active]

  defstruct [
    :id,
    :template_id,
    :name,
    :alias,
    :description,
    :area_type,
    :content_type,
    :has_subpages,
    :code,
    :active,
    :content
  ]

  def get_content(%__MODULE__{content_type: cType, content: content}),
    do: Map.get(content, String.to_atom(cType), nil)

  def get_content(x), do: x
end
