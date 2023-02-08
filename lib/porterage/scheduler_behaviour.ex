defmodule Porterage.SchedulerBehaviour do
  @moduledoc """
  Behaviour every scheduler is expected to implement.
  """

  @type state :: any
  @type tick_result :: {state, boolean}

  @optional_callbacks [init: 1]

  @doc """
  Optional state initialization.
  """
  @callback init(opts :: map) :: state

  @doc """
  Execute a run of the scheduler module.
  """
  @callback tick(state :: any) :: tick_result
end
