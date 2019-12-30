defmodule Porterage.TesterState do
  @moduledoc false

  @type t :: %__MODULE__{
          tester: module,
          supervisor: pid
        }

  defstruct [:supervisor, :tester]
end
