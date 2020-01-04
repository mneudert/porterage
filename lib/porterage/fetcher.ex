defmodule Porterage.Fetcher do
  @moduledoc """
  Porterage fetcher
  """

  use GenServer

  alias Porterage.FetcherState
  alias Porterage.Supervisor

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, fetcher, opts]) do
    substate =
      if Code.ensure_loaded?(fetcher) and function_exported?(fetcher, :init, 1) do
        fetcher.init(opts)
      end

    {:ok, %FetcherState{fetcher: fetcher, substate: substate, supervisor: supervisor}}
  end

  def handle_cast(:fetch, %FetcherState{fetcher: fetcher, substate: substate} = state) do
    case fetcher.fetch(substate) do
      {:ok, data} -> notify_deliverer(state, data)
      _ -> :ok
    end

    {:noreply, state}
  end

  @optional_callbacks [init: 1]

  @doc """
  Execute a run of the fetcher module.
  """
  @callback fetch(state :: any) :: {:ok, any} | any

  @doc """
  Optional state initialization.
  """
  @callback init(opts :: map) :: any

  defp notify_deliverer(%FetcherState{supervisor: supervisor}, data) do
    case Supervisor.child(supervisor, Porterage.Deliverer) do
      deliverer when is_pid(deliverer) -> GenServer.cast(deliverer, {:deliver, data})
      _ -> :ok
    end
  end
end
