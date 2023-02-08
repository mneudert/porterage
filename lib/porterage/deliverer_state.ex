defmodule Porterage.DelivererState do
  @moduledoc false

  alias Porterage.DelivererBehaviour

  @type t :: %__MODULE__{
          deliverer: module,
          substate: DelivererBehaviour.state(),
          supervisor: pid
        }

  defstruct [:deliverer, :substate, :supervisor]
end
