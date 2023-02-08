defmodule Porterage.Scheduler.Never do
  @moduledoc """
  Scheduler ignoring all trigger requests to force only manual fetching.

  ## Configuration

      {
        scheduler: Porterage.Scheduler.Never
      }
  """

  @behaviour Porterage.SchedulerBehaviour

  @impl Porterage.SchedulerBehaviour
  def tick(state), do: {state, false}
end
