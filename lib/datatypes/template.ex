defmodule Netflex.DataTypes.Template do
  use Netflex.Mutators.ContentApi,
    integer: [:id]

  defstruct [:id, :name, :alias, :description, :body, :controller, :config, :areas]

  def convert_config(%{config: %{} = config} = payload) do
    Map.put(
      payload,
      :config,
      Enum.map(config, fn
        {key, %{value: v}} ->
          {key, v}

        {key, _} ->
          {key, nil}
      end)
      |> Enum.reduce(%{}, fn {key, value}, payload ->
        Map.put(payload, key, value)
      end)
    )
  end

  def convert_config(%{config: nil} = payload), do: payload
end
