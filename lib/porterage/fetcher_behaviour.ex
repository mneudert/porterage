defmodule Porterage.FetcherBehaviour do
  @moduledoc """
  Behaviour every fetcher is expected to implement.
  """

  @type state :: any
  @type fetch_result :: {:ok, state, any} | {:ok, state}

  @optional_callbacks [init: 1]

  @doc """
  Execute a run of the fetcher module.
  """
  @callback fetch(state :: any) :: fetch_result

  @doc """
  Optional state initialization.
  """
  @callback init(opts :: map) :: state
end
