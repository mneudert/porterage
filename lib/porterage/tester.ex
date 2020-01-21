defmodule Porterage.Tester do
  @moduledoc """
  Porterage tester
  """

  use GenServer

  alias Porterage.TesterState

  @type state :: map
  @type test_result :: {state, boolean}

  @doc false
  def start_link([_, nil, _]), do: :ignore

  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, tester, opts]) do
    substate =
      if Code.ensure_loaded?(tester) and function_exported?(tester, :init, 1) do
        tester.init(opts)
      end

    {:ok, %TesterState{substate: substate, supervisor: supervisor, tester: tester}}
  end

  def handle_cast(
        :test,
        %TesterState{substate: substate, supervisor: supervisor, tester: tester} = state
      ) do
    {new_substate, notify?} = tester.test(substate)

    if notify? do
      :ok = Porterage.fetch(supervisor)
    end

    {:noreply, %{state | substate: new_substate}}
  end

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
