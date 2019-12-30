defmodule Porterage.SchedulerState do
  @moduledoc false

  @type t :: %__MODULE__{
          scheduler: module,
          supervisor: pid
        }

  defstruct [:scheduler, :supervisor]
end
