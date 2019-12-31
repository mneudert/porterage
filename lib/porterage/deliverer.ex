defmodule Porterage.Deliverer do
  @moduledoc """
  Porterage deliverer
  """

  use GenServer

  alias Porterage.DelivererState

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, deliverer]) do
    substate =
      if function_exported?(deliverer, :init, 0) do
        deliverer.init()
      end

    {:ok, %DelivererState{deliverer: deliverer, substate: substate, supervisor: supervisor}}
  end

  def handle_cast(
        {:deliver, data},
        %DelivererState{deliverer: deliverer, substate: substate} = state
      ) do
    deliverer.deliver(substate, data)

    {:noreply, state}
  end

  @optional_callbacks [init: 0]

  @doc """
  Execute a run of the deliverer module.
  """
  @callback deliver(state :: any, data :: any) :: any

  @doc """
  Optional state initialization.
  """
  @callback init() :: any
end
