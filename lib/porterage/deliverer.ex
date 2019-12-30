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
    {:ok, %DelivererState{supervisor: supervisor, deliverer: deliverer}}
  end

  def handle_cast({:deliver, data}, %DelivererState{deliverer: deliverer} = state) do
    deliverer.deliver(data)

    {:noreply, state}
  end

  @doc """
  Execute a run of the deliverer module.
  """
  @callback deliver(any) :: any
end
