defmodule Porterage.TesterState do
  @moduledoc false

  alias Porterage.TesterBehaviour

  @type t :: %__MODULE__{
          substate: TesterBehaviour.state(),
          supervisor: pid,
          tester: module
        }

  defstruct [:substate, :supervisor, :tester]
end
