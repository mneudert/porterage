defmodule Porterage.DelivererState do
  @moduledoc false

  @type t :: %__MODULE__{
          deliverer: module,
          substate: any,
          supervisor: pid
        }

  defstruct [:deliverer, :substate, :supervisor]
end
