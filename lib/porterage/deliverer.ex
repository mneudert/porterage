defmodule Porterage.Deliverer do
  @moduledoc """
  Delivers a data package to a configured destination.
  """

  use GenServer

  require Logger

  alias Porterage.DelivererState

  @type state :: any

  @doc false
  def start_link([_, nil, _]), do: :ignore

  def start_link([_, deliverer, _] = config) do
    if Code.ensure_loaded?(deliverer) do
      GenServer.start_link(__MODULE__, config)
    else
      _ = Logger.warning(["Could not load deliverer module: ", inspect(deliverer)])
      :ignore
    end
  end

  @impl GenServer
  def init([supervisor, deliverer, opts]) do
    substate =
      if function_exported?(deliverer, :init, 1) do
        deliverer.init(opts)
      end

    {:ok, %DelivererState{deliverer: deliverer, substate: substate, supervisor: supervisor}}
  end

  @impl GenServer
  def handle_cast(
        {:deliver, data},
        %DelivererState{deliverer: deliverer, substate: substate} = state
      ) do
    new_substate = deliverer.deliver(substate, data)

    {:noreply, %{state | substate: new_substate}}
  end

  @optional_callbacks [init: 1]

  @doc """
  Execute a run of the deliverer module.
  """
  @callback deliver(state :: state, data :: any) :: state

  @doc """
  Optional state initialization.
  """
  @callback init(opts :: map) :: state
end
