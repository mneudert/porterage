defmodule Porterage.TestHelpers.DummyScheduler do
  @moduledoc false

  @behaviour Porterage.SchedulerBehaviour

  @impl Porterage.SchedulerBehaviour
  def init(%{parent: parent, send_init: send_init} = state) do
    send(parent, send_init)
    state
  end

  def init(state), do: state

  @impl Porterage.SchedulerBehaviour
  def tick(%{parent: parent, return_tick: return_tick, send_tick: send_tick} = state) do
    send(parent, send_tick)
    {state, return_tick}
  end

  def tick(%{return_tick: return_tick} = state), do: {state, return_tick}
end
