defmodule Porterage.Scheduler.Once do
  @moduledoc """
  Scheduler triggering once upon startup.
  """

  @behaviour Porterage.Scheduler

  @impl Porterage.Scheduler
  def tick(state), do: {state, true}
end
