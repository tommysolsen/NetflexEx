defprotocol Netflex.Mutator do
  @fallback_to_any true
  def encode(structure)
  def decode(structure)
end

defimpl Netflex.Mutator, for: Any do
  @spec encode(any) :: any
  def encode(structure), do: structure

  @spec decode(any) :: any
  def decode(structure), do: structure
end
