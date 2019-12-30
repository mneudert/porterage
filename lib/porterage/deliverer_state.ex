defmodule Porterage.DelivererState do
  @moduledoc false

  @type t :: %__MODULE__{
          deliverer: module,
          supervisor: pid
        }

  defstruct [:deliverer, :supervisor]
end
