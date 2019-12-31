defmodule Porterage.Tester do
  @moduledoc """
  Porterage tester
  """

  use GenServer

  alias Porterage.Supervisor
  alias Porterage.TesterState

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, tester]) do
    substate =
      if function_exported?(tester, :init, 0) do
        tester.init()
      end

    {:ok, %TesterState{substate: substate, supervisor: supervisor, tester: tester}}
  end

  def handle_cast(:test, %TesterState{substate: substate, tester: tester} = state) do
    if tester.test(substate) do
      :ok = notify_fetcher(state)
    end

    {:noreply, state}
  end

  @optional_callbacks [init: 0]

  @doc """
  Optional state initialization.
  """
  @callback init() :: any

  @doc """
  Execute a run of the tester module.
  """
  @callback test(state :: any) :: boolean

  defp notify_fetcher(%TesterState{supervisor: supervisor}) do
    case Supervisor.child(supervisor, Porterage.Fetcher) do
      fetcher when is_pid(fetcher) -> GenServer.cast(fetcher, :fetch)
      _ -> :ok
    end
  end
end
