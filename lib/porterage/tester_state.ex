defmodule Porterage.TesterState do
  @moduledoc false

  @type t :: %__MODULE__{
          substate: any,
          supervisor: pid,
          tester: module
        }

  defstruct [:substate, :supervisor, :tester]
end
