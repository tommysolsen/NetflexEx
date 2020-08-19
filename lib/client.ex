defmodule Netflex.Client do
  @moduledoc """
  Netflex is a http client authenticated against the Netflex site of choice
  """

  use HTTPoison.Base

  @doc """

  iex> Netflex.process_request_url("test")
  "https://capi.netflexapp.com/test"
  """
  def process_request_url(url) do
    (Application.get_env(:netflex, __MODULE__, [])
     |> Keyword.get(:base_path)) <> url
  end

  def process_request_options(options) do
    hackney_opts =
      options
      |> Keyword.get(:hakney, [])
      |> Keyword.put(:basic_auth, get_username_password())

    options
    |> Keyword.put(:hackney, hackney_opts)
  end

  def process_response_body(body) when is_list(body) do
    Enum.map(body, &process_response_body/1)
  end

  def process_response_body(body) do
    Jason.decode!(body, keys: :atoms)
    |> Enum.map(&Netflex.Mutator.decode/1)
  end

  defp get_username_password() do
    {
      Application.get_env(:netflex, __MODULE__, [])
      |> Keyword.get(:public_key),
      Application.get_env(:netflex, __MODULE__, [])
      |> Keyword.get(:private_key)
    }
  end
end
