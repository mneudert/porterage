defmodule Porterage.SchedulerState do
  @moduledoc false

  alias Porterage.Scheduler

  @type t :: %__MODULE__{
          scheduler: module,
          substate: Scheduler.state(),
          supervisor: pid
        }

  defstruct [:scheduler, :substate, :supervisor]
end
