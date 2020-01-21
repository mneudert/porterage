defmodule Porterage.Scheduler do
  @moduledoc """
  Porterage scheduler
  """

  use GenServer

  alias Porterage.SchedulerState

  @type state :: map
  @type tick_result :: {state, boolean}

  @doc false
  def start_link([_, nil, _]), do: :ignore

  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, scheduler, opts]) do
    substate =
      if Code.ensure_loaded?(scheduler) and function_exported?(scheduler, :init, 1) do
        scheduler.init(opts)
      end

    :ok = GenServer.cast(self(), :tick)

    {:ok, %SchedulerState{scheduler: scheduler, substate: substate, supervisor: supervisor}}
  end

  def handle_cast(
        :tick,
        %SchedulerState{scheduler: scheduler, substate: substate, supervisor: supervisor} = state
      ) do
    {new_substate, notify?} = scheduler.tick(substate)

    if notify? do
      :ok = Porterage.test(supervisor)
    end

    {:noreply, %{state | substate: new_substate}}
  end

  def handle_info(:tick, state), do: handle_cast(:tick, state)

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
