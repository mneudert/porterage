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
    {:ok, %TesterState{supervisor: supervisor, tester: tester}}
  end

  def handle_cast(:test, %TesterState{tester: tester} = state) do
    if tester.test() do
      :ok = notify_fetcher(state)
    end

    {:noreply, state}
  end

  @doc """
  Execute a run of the tester module.
  """
  @callback test() :: boolean

  defp notify_fetcher(%TesterState{supervisor: supervisor}) do
    case Supervisor.child(supervisor, Porterage.Fetcher) do
      fetcher when is_pid(fetcher) -> GenServer.cast(fetcher, :fetch)
      _ -> :ok
    end
  end
end
