defmodule Porterage.FetcherState do
  @moduledoc false

  alias Porterage.Fetcher

  @type t :: %__MODULE__{
          fetcher: module,
          substate: Fetcher.state(),
          supervisor: pid
        }

  defstruct [:fetcher, :substate, :supervisor]
end
