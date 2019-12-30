defmodule Porterage.Fetcher do
  @moduledoc """
  Porterage fetcher
  """

  use GenServer

  alias Porterage.FetcherState

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, fetcher]) do
    {:ok, %FetcherState{supervisor: supervisor, fetcher: fetcher}}
  end

  def handle_cast(:fetch, %FetcherState{fetcher: fetcher} = state) do
    case fetcher.fetch() do
      {:ok, data} -> notify_deliverer(state, data)
      _ -> :ok
    end

    {:noreply, state}
  end

  @doc """
  Execute a run of the fetcher module.
  """
  @callback fetch() :: {:ok, any} | any

  defp notify_deliverer(%FetcherState{supervisor: supervisor}, data) do
    case Porterage.Supervisor.child(supervisor, Porterage.Deliverer) do
      deliverer when is_pid(deliverer) -> GenServer.cast(deliverer, {:deliver, data})
      _ -> :ok
    end
  end
end
