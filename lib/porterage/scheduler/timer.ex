defmodule Porterage.Scheduler.Timer do
  @moduledoc """
  Scheduler triggering repeatedly after configurable time.
  """

  @behaviour Porterage.Scheduler

  @impl Porterage.Scheduler
  def init(%{time: _} = state), do: state

  @impl Porterage.Scheduler
  def tick(%{time: send_after} = state) do
    Process.send_after(self(), :tick, send_after)
    {state, true}
  end
end
