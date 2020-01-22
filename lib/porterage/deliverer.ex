defmodule Porterage.Deliverer do
  @moduledoc """
  Porterage deliverer
  """

  use GenServer

  alias Porterage.DelivererState

  @type state :: map

  @doc false
  def start_link([_, nil, _]), do: :ignore

  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, deliverer, opts]) do
    substate =
      if Code.ensure_loaded?(deliverer) and function_exported?(deliverer, :init, 1) do
        deliverer.init(opts)
      end

    {:ok, %DelivererState{deliverer: deliverer, substate: substate, supervisor: supervisor}}
  end

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
