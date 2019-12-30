defmodule Porterage.FetcherState do
  @moduledoc false

  @type t :: %__MODULE__{
          fetcher: module,
          supervisor: pid
        }

  defstruct [:fetcher, :supervisor]
end
