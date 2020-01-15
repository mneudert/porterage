defmodule Porterage.Scheduler.Never do
  @moduledoc """
  Scheduler ignoring all trigger requests to force only manual fetching.
  """

  @behaviour Porterage.Scheduler

  @impl Porterage.Scheduler
  def tick(state), do: {state, false}
end
