defmodule Porterage.SchedulerState do
  @moduledoc false

  alias Porterage.SchedulerBehaviour

  @type t :: %__MODULE__{
          scheduler: module,
          substate: SchedulerBehaviour.state(),
          supervisor: pid
        }

  defstruct [:scheduler, :substate, :supervisor]
end
