defmodule Porterage.Scheduler do
  @moduledoc """
  Takes care of (periodically) triggering the chosen tester module.
  """

  use GenServer

  require Logger

  alias Porterage.SchedulerState

  @doc false
  def start_link([_, nil, _]), do: :ignore

  def start_link([_, scheduler, _] = config) do
    if Code.ensure_loaded?(scheduler) do
      GenServer.start_link(__MODULE__, config)
    else
      _ = Logger.warning(["Could not load scheduler module: ", inspect(scheduler)])
      :ignore
    end
  end

  @impl GenServer
  def init([supervisor, scheduler, opts]) do
    substate =
      if function_exported?(scheduler, :init, 1) do
        scheduler.init(opts)
      end

    :ok = GenServer.cast(self(), :tick)

    {:ok, %SchedulerState{scheduler: scheduler, substate: substate, supervisor: supervisor}}
  end

  @impl GenServer
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

  @impl GenServer
  def handle_info(:tick, state), do: handle_cast(:tick, state)
end
