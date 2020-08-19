defmodule Netflex do
  use GenServer

  def start(_, args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, args}
  end

  def get_page_by_id(id) do
    GenServer.call(__MODULE__, {:page_by_id, id})
  end

  def handle_call({:refresh, _from, :pages}, state) do
    %HTTPoison.Response{body: response_body, status_code: 200} =
      Netflex.Client.get!("builder/pages")

    {:reply, {:ok, "fetched"}, %{state | pages: response_body}}
  end

  def handle_call({:page_by_id, id}, _from, %{state: pages} = state) do
    case Enum.find(pages, nil, &(Map.get(&1, :id, nil) == id)) do
      nil -> {:reply, {:error, "page not found"}, state}
      x -> {:reply, {:ok, x}, state}
    end
  end
end
