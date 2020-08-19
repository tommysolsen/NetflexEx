defmodule Netflex.Mutators.ContentApi do
  defmacro __using__(arguments) do
    quote do
      defimpl Netflex.Mutator, for: __MODULE__ do
        def encode(%{} = payload) do
          Enum.reduce(unquote(arguments), payload, fn {type, keys}, pl ->
            Enum.reduce(keys, pl, fn key, pl2 ->
              Map.put(pl2, key, Netflex.Mutators.ContentApi.encode(type, Map.get(pl2, key)))
            end)
          end)
        end

        def decode(%{} = payload) do
          Enum.reduce(unquote(arguments), payload, fn {type, keys}, pl ->
            Enum.reduce(keys, pl, fn key, pl2 ->
              Map.put(pl2, key, Netflex.Mutators.ContentApi.decode(type, Map.get(pl2, key)))
            end)
          end)
        end
      end
    end
  end

  def encode(_, nil), do: nil
  def encode(:boolean, true), do: "1"
  def encode(:boolean, false), do: "0"

  def encode(:integer, x) when is_integer(x), do: Integer.to_string(x)

  def decode(_, nil), do: nil
  def decode(:boolean, "1"), do: true
  def decode(:boolean, "0"), do: false

  def decode(:integer, x) do
    case Integer.parse(x) do
      {val, ""} -> val
      _ -> throw("Unable to parse integer: #{x}")
    end
  end
end
