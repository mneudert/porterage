defmodule Porterage.TesterState do
  @moduledoc false

  alias Porterage.Tester

  @type t :: %__MODULE__{
          substate: Tester.state(),
          supervisor: pid,
          tester: module
        }

  defstruct [:substate, :supervisor, :tester]
end
