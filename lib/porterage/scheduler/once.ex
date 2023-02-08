defmodule Porterage.Scheduler.Once do
  @moduledoc """
  Scheduler triggering once upon startup.

  ## Configuration

      {
        scheduler: Porterage.Scheduler.Once
      }
  """

  @behaviour Porterage.SchedulerBehaviour

  @impl Porterage.SchedulerBehaviour
  def tick(state), do: {state, true}
end
