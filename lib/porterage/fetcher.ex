defmodule Porterage.Fetcher do
  @moduledoc """
  Porterage fetcher
  """

  use GenServer

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, fetcher]) do
    {:ok, %{supervisor: supervisor, fetcher: fetcher}}
  end

  def handle_cast(:fetch, %{fetcher: fetcher} = state) do
    fetcher.fetch()

    {:noreply, state}
  end

  @doc """
  Execute a run of the fetcher module.
  """
  @callback fetch() :: boolean
end
