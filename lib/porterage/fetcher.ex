defmodule Porterage.Fetcher do
  @moduledoc """
  Tries to fetch the configured data source and pass it on for delivery.
  """

  use GenServer

  require Logger

  alias Porterage.FetcherState

  @doc false
  def start_link([_, nil, _]), do: :ignore

  def start_link([_, fetcher, _] = config) do
    if Code.ensure_loaded?(fetcher) do
      GenServer.start_link(__MODULE__, config)
    else
      _ = Logger.warning(["Could not load fetcher module: ", inspect(fetcher)])
      :ignore
    end
  end

  @impl GenServer
  def init([supervisor, fetcher, opts]) do
    substate =
      if function_exported?(fetcher, :init, 1) do
        fetcher.init(opts)
      end

    {:ok, %FetcherState{fetcher: fetcher, substate: substate, supervisor: supervisor}}
  end

  @impl GenServer
  def handle_cast(
        :fetch,
        %FetcherState{fetcher: fetcher, substate: substate, supervisor: supervisor} = state
      ) do
    new_substate =
      case fetcher.fetch(substate) do
        {:ok, new_substate, data} ->
          :ok = Porterage.deliver(supervisor, data)
          new_substate

        {:ok, new_substate} ->
          new_substate
      end

    {:noreply, %{state | substate: new_substate}}
  end
end
