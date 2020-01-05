defmodule Porterage.DelivererState do
  @moduledoc false

  alias Porterage.Deliverer

  @type t :: %__MODULE__{
          deliverer: module,
          substate: Deliverer.state(),
          supervisor: pid
        }

  defstruct [:deliverer, :substate, :supervisor]
end
