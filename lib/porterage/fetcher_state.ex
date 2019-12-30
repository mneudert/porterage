defmodule Porterage.FetcherState do
  @moduledoc false

  @type t :: %__MODULE__{
          fetcher: module,
          substate: any,
          supervisor: pid
        }

  defstruct [:fetcher, :substate, :supervisor]
end
