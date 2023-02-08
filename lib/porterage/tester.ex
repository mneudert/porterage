defmodule Porterage.Tester do
  @moduledoc """
  Tests if data should be fetched and delivered after the last scheduler tick.
  """

  use GenServer

  require Logger

  alias Porterage.TesterState

  @doc false
  def start_link([_, nil, _]), do: :ignore

  def start_link([_, tester, _] = config) do
    if Code.ensure_loaded?(tester) do
      GenServer.start_link(__MODULE__, config)
    else
      _ = Logger.warning(["Could not load tester module: ", inspect(tester)])
      :ignore
    end
  end

  @impl GenServer
  def init([supervisor, tester, opts]) do
    substate =
      if function_exported?(tester, :init, 1) do
        tester.init(opts)
      end

    {:ok, %TesterState{substate: substate, supervisor: supervisor, tester: tester}}
  end

  @impl GenServer
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
end
