defmodule Porterage.Scheduler do
  @moduledoc """
  Porterage scheduler
  """

  use GenServer

  alias Porterage.SchedulerState
  alias Porterage.Supervisor

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, scheduler]) do
    substate =
      if function_exported?(scheduler, :init, 0) do
        scheduler.init()
      end

    :ok = GenServer.cast(self(), :tick)

    {:ok, %SchedulerState{scheduler: scheduler, substate: substate, supervisor: supervisor}}
  end

  def handle_cast(:tick, %SchedulerState{scheduler: scheduler, substate: substate} = state) do
    if scheduler.tick(substate) do
      :ok = notify_tester(state)
    end

    {:noreply, state}
  end

  defp notify_tester(%SchedulerState{supervisor: supervisor}) do
    case Supervisor.child(supervisor, Porterage.Tester) do
      tester when is_pid(tester) -> GenServer.cast(tester, :test)
      _ -> :ok
    end
  end

  @optional_callbacks [init: 0]

  @doc """
  Optional state initialization.
  """
  @callback init() :: any

  @doc """
  Execute a run of the scheduler module.
  """
  @callback tick(state :: any) :: boolean
end
