defmodule Porterage.TesterBehaviour do
  @moduledoc """
  Behaviour every tester is expected to implement.
  """

  @type state :: any
  @type test_result :: {state, boolean}

  @optional_callbacks [init: 1]

  @doc """
  Optional state initialization.
  """
  @callback init(opts :: map) :: state

  @doc """
  Execute a run of the tester module.
  """
  @callback test(state :: any) :: test_result
end
