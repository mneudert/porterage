defmodule Porterage.FetcherState do
  @moduledoc false

  alias Porterage.FetcherBehaviour

  @type t :: %__MODULE__{
          fetcher: module,
          substate: FetcherBehaviour.state(),
          supervisor: pid
        }

  defstruct [:fetcher, :substate, :supervisor]
end
