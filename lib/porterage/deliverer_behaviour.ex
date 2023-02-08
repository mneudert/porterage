defmodule Porterage.DelivererBehaviour do
  @moduledoc """
  Behaviour every deliverer is expected to implement.
  """

  @type state :: any

  @optional_callbacks [init: 1]

  @doc """
  Execute a run of the deliverer module.
  """
  @callback deliver(state :: state, data :: any) :: state

  @doc """
  Optional state initialization.
  """
  @callback init(opts :: map) :: state
end
