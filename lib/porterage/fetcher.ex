defmodule Porterage.Fetcher do
  @moduledoc """
  Porterage fetcher
  """

  use GenServer

  alias Porterage.FetcherState
  alias Porterage.SupervisorUtil

  @type state :: map
  @type fetch_result :: {:ok, state, any} | {:ok, state}

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
    new_substate =
      case fetcher.fetch(substate) do
        {:ok, new_substate, data} ->
          :ok = notify_deliverer(state, data)
          new_substate

        {:ok, new_substate} ->
          new_substate
      end

    {:noreply, %{state | substate: new_substate}}
  end

  @optional_callbacks [init: 1]

  @doc """
  Execute a run of the fetcher module.
  """
  @callback fetch(state :: any) :: fetch_result

  @doc """
  Optional state initialization.
  """
  @callback init(opts :: map) :: state

  defp notify_deliverer(%FetcherState{supervisor: supervisor}, data) do
    case SupervisorUtil.child(supervisor, Porterage.Deliverer) do
      deliverer when is_pid(deliverer) -> GenServer.cast(deliverer, {:deliver, data})
      _ -> :ok
    end
  end
end
