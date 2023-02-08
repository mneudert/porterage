defmodule Porterage.Scheduler.Timer do
  @moduledoc """
  Scheduler triggering repeatedly after configurable time.

  ## Configuration

      {
        scheduler: Porterage.Scheduler.Timer,
        scheduler_opts: %{time: _}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{time: non_neg_integer}

  @behaviour Porterage.SchedulerBehaviour

  @impl Porterage.SchedulerBehaviour
  def init(%{time: _} = state), do: state

  @impl Porterage.SchedulerBehaviour
  def tick(%{time: send_after} = state) do
    Process.send_after(self(), :tick, send_after)
    {state, true}
  end
end
