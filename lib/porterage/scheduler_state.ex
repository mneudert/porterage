defmodule Porterage.SchedulerState do
  @moduledoc false

  @type t :: %__MODULE__{
          scheduler: module,
          substate: any,
          supervisor: pid
        }

  defstruct [:scheduler, :substate, :supervisor]
end
