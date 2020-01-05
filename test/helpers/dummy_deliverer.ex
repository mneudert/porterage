defmodule Porterage.TestHelpers.DummyDeliverer do
  @moduledoc false

  @behaviour Porterage.Deliverer

  @impl Porterage.Deliverer
  def init(%{parent: parent, send_init: send_init} = state) do
    send(parent, send_init)
    state
  end

  def init(state), do: state

  @impl Porterage.Deliverer
  def deliver(%{parent: parent} = state, data) do
    send(parent, data)
    state
  end

  def deliver(state, _), do: state
end
